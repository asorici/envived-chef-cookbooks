#include_recipe "server"
#include_recipe "nginx::latest"
#include_recipe "myapp::directories"
include_recipe "mysql::server"
include_recipe "database"
include_recipe "apache2"
include_recipe "memcached"


# Setup Envived MySQL database
mysql_database "create envived database" do
  host "localhost"
  username "root"
  password node[:mysql][:server_root_password]
  database node[:apps][:envived][:database][:name]
  action :create_db
end

mysql_connection_info = {
  :host => "localhost",
  :username => 'root',
  :password => node['mysql']['server_root_password']
}

mysql_database_user 'envived' do
  connection mysql_connection_info
  password 'GroundAce55'
  database_name node[:apps][:envived][:database][:name]
  privileges [:all]
  action :grant
end


# Setup Apache server configuration and custom django.wsgi file
web_app "envived" do
  template "apache2/envived-apache.conf.erb"
  server_name "envived.com"
  server_aliases ["www.envived.com"]
  docroot node[:apps][:envived][:project_root]
  
  wsgi_daemon_process_user "envived"
  wsgi_daemon_process_group "envived"
  wsgi_daemon_process_threads 10
end

cookbook_file "#{node[:apps][:envived][:project_root]}/etc/django.wsgi" do
  source "django.wsgi"
  owner "envived"
  group "envived"
  mode "0644"
end
