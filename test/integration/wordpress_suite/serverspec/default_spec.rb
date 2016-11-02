require 'spec_helper'

describe 'yum check-update' do
  it 'yum check-update to return 0' do
    expect(system('yum check-update')).to be true
  end
end

%w( epel-release nginx php php-mysql php-fpm mariadb-server mariadb ).each do |pkg|
  describe package(pkg) do
    it { should be_installed }
  end
end

describe service('nginx') do
  it { should be_enabled }
  it { should be_running }
end

describe service('mariadb.service') do
  it { should be_running }
end

describe 'mysql information_schema' do
  it 'the information_schema is present' do
    expect(`mysql -ppassword -u root -e 'show databases'`).to contain('information_schema')
  end
end

describe service('mariadb.service') do
  it { should be_enabled }
end

# This may fail if the deployment isn't fresh.
# describe file("/etc/nginx/nginx.conf-#{Time.now.strftime('%m-%d-%Y_%H-%M')}") do
#   it { should exist }
# end

describe file('/etc/nginx/nginx.conf') do
  it { should exist }
end

describe file('/etc/php.ini') do
  it { should exist }
end

describe file('/etc/php-fpm.d/www.conf') do
  it { should exist }
end

describe service('php-fpm') do
  it { should be_enabled }
  it { should be_running }
end

describe file('/usr/share/nginx/html') do
  it { should be_owned_by 'nginx' }
end

describe file('/etc/nginx/conf.d/default.conf') do
  it { should exist }
end

describe service('nginx') do
  it { should be_running }
end

describe file('/usr/share/nginx/html/info.php') do
  it { should exist }
end

describe host('192.168.33.33') do
  it { should be_reachable }
end
