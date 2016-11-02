execute 'yum update' do
  command 'yum -y update'
  not_if "yum check-update"
end

%w(epel-release nginx php php-mysql php-fpm mariadb-server mariadb).each do |p|
  package p
end

service 'nginx' do
  supports status: true, restart: true, reload: true, stop: true
  action :enable
end

service 'mariadb.service' do
  action :restart
end

bash 'configure mysql' do
  code <<-EOH
    mysqladmin -u root password "password"
    mysql -u root -ppassword -e "DELETE FROM mysql.user WHERE User='';"
    mysql -u root -ppassword -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1');"
    mysql -u root -ppassword -e "DROP DATABASE test;"
    mysql -u root -ppassword -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
    mysql -u root -ppassword -e "FLUSH PRIVILEGES;"
  EOH
  action :run
  only_if "mysql -u root -e 'show databases' | grep information_schema"
end

service 'mariadb.service' do
  supports status: true, restart: true, reload: true
  action :enable
end

ruby_block 'Back up nginx config file' do
  block do
    ::FileUtils.cp '/etc/nginx/nginx.conf', "/etc/nginx/nginx.conf-#{Time.now.strftime('%m-%d-%Y_%H-%M')}"
  end
  not_if { ::File.exist?("/etc/nginx/nginx.conf-#{Time.now.strftime('%m-%d-%Y_%H-%M')}") }
end

template '/etc/nginx/nginx.conf' do
  source 'nginx.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

template '/etc/php.ini' do
  source 'php.ini.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

template '/etc/php-fpm.d/www.conf' do
  source 'www.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

service 'php-fpm' do
  supports status: true, restart: true, reload: true, start: true
  action [:enable, :start, :restart]
  notifies :start, 'service[php-fpm]', :immediate
end

# service 'php-fpm' do
#   action :start
# end

execute 'chown -R nginx:nginx /usr/share/nginx/html'

template '/etc/nginx/conf.d/default.conf' do
  source 'default.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, 'service[nginx]', :immediate
end

# service 'nginx' do
#   action :restart
# end

# NOTE: This should be deleted before deploying to prod.
template '/usr/share/nginx/html/info.php' do
  source 'info.php.erb'
  owner 'root'
  group 'root'
  mode '0644'
end
