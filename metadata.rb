name             'chef-wordpress'
maintainer       'Rob'
maintainer_email 'robertsdeheer@gmail.com'
license          ''
description      'Chef wordpress demo'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.0'
%w( centos-7.2 ).each do |os|
  supports os
end

recipe 'chef-wordpress::default', 'Installs nginx, php, mysql, deploys and app and configures the system.'

# depends 'et_elk', '= 4.0.1'

# attribute "WordPress/version",
#   :display_name => "WordPress download version",
#   :description => "Version of WordPress to download from the WordPress site or 'latest' for the current release.",
#   :default => "latest"
