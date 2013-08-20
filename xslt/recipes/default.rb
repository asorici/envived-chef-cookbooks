#
# Cookbook Name:: xslt
# Recipe:: default
#
#

package "libxslt" do
  package_name value_for_platform(
    "ubuntu" => {"default" => "libxslt1.1"},
    "default" => "libxslt"
  )
end

package "libxslt-dev" do
  package_name value_for_platform(
    %w[centos redhat scientific suse fedora] => { "default" => "libxslt-devel" },
    "ubuntu" => {"default" => "libxslt1-dev"},
    "default" => "libxslt-dev"
  )
end
