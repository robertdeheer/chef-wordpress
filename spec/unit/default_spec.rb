require 'spec_helper'

describe 'chef-wordpress::default' do
  before(:each) do
    stub_command("mysql -u root -e 'show databases' | grep information_schema").and_return(true)
  end

  let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '12.04').converge(described_recipe) }

  it 'runs yum update' do
    expect(chef_run).to run_execute('yum -y update')
  end

  it 'installs epel-release' do
    expect(chef_run).to install_package('epel-release')
  end

  it 'installs nginx' do
    expect(chef_run).to install_package('nginx')
  end

  it 'installs php' do
    expect(chef_run).to install_package('php')
  end

  it 'installs php-mysql' do
    expect(chef_run).to install_package('php-mysql')
  end

  it 'installs php-fpm' do
    expect(chef_run).to install_package('php-fpm')
  end

  it 'installs mariadb-server' do
    expect(chef_run).to install_package('mariadb-server')
  end

  it 'installs mariadb' do
    expect(chef_run).to install_package('mariadb')
  end

  it 'enables service nginx' do
    expect(chef_run).to enable_service('nginx')
  end

  it 'restarts service mariadb.service' do
    expect(chef_run).to restart_service('mariadb.service')
  end

  # Not interpreting guard properly
  it 'configures mysql' do
    expect(chef_run).to run_bash('configure mysql')
  end

  it 'enables service mariadb.service' do
    expect(chef_run).to enable_service('mariadb.service')
  end

  it 'enables service mariadb.service' do
    expect(chef_run).to enable_service('mariadb.service')
  end

  it 'backs up nginx.conf' do
    expect(chef_run).to run_ruby_block('Back up nginx config file')
  end

  it 'installs template nginx.conf' do
    expect(chef_run).to create_template('/etc/nginx/nginx.conf')
  end

  it 'installs template php.ini' do
    expect(chef_run).to create_template('/etc/php.ini')
  end

  it 'installs template www.conf' do
    expect(chef_run).to create_template('/etc/php-fpm.d/www.conf')
  end

  it 'enables service php-fpm' do
    expect(chef_run).to enable_service('php-fpm')
  end

  it 'restarts service php-fpm' do
    expect(chef_run).to restart_service('php-fpm')
  end

  it 'changes perms' do
    expect(chef_run).to run_execute('chown -R nginx:nginx /usr/share/nginx/html')
  end

  it 'installs template nginx default.conf' do
    expect(chef_run).to create_template('/etc/nginx/conf.d/default.conf')
  end

  it 'restarts service nginx' do
    expect(chef_run).to restart_service('nginx')
  end

  it 'installs template info.php' do
    expect(chef_run).to create_template('/usr/share/nginx/html/info.php')
  end
end
