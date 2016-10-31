# chef-wordpress

Wordpress site built with Chef. Write a cookbook for deployment and configuration of WEB application (WP-site).  

OS: CentOS 7.  

Don’t use 3rd-party cookbooks for nginx, php.  

## Level 1:

    Install necessary packages: (nginx, php, mysql, ...)  
    Make changes in nginx/php configs (increase php allowed memory, add nginx virtual host, etc) using templates  
    Deploy application from git using private repo (auth by key)  
    Generate local config files (wp-config.php)  

## Level 2:

    Use encrypted data bag for DB credentials storage

## Level 3:

    Write tests for cookbook

## Level 4 (optional):

    Generate docker image using this cookbook
