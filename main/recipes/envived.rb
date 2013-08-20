#Virtualenv setup

directory "/home/envived/sites/" do
    owner "envived"
    group "envived"
    mode 0775
end

#directory "/home/envived/sites/envived.com/run" do
#    owner "envived"
#    group "envived"
#    mode 0775
#end

git "/home/envived/sites/envived.com/envived" do
  repository "git@github.com:asorici/envived.git"
  reference "HEAD"
  user "envived"
  group "envived"
  action :sync
end

virtualenv "/home/envived/sites/envived.com" do
    owner "envived"
    group "envived"
    mode 0775
    requirements "/home/envived/sites/envived.com/envived/requirements.txt"
end

# Gunicorn setup

#cookbook_file "/etc/init/readthedocs-gunicorn.conf" do
#    source "gunicorn.conf"
#    owner "root"
#    group "root"
#    mode 0644
#end

#service "readthedocs-gunicorn" do
#    provider Chef::Provider::Service::Upstart
#    enabled true
#    running true
#    supports :restart => true, :reload => true, :status => true
#    action [:enable, :start]
#end

cookbook_file "/home/envived/.bash_profile" do
    source "bash_profile"
    owner "envived"
    group "envived"
    mode 0755
end

