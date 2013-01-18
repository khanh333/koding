include_recipe "apt::10gen"

gem_package "mongo" do
  action :install
end

package node['mongodb']['package_name'] do
  version node['mongodb']['version']
  action :install
  options "-o Dpkg::Options::='--force-confold' "
  only_if do
      File.exists?(node['mongodb']['data_device'])
      File.exists?(node['mongodb']['log_device'])
  end
end

directory node['mongodb']['dbpath'] do
  owner "mongodb"
  group "mongodb"
  mode 00755
  action :nothing
  subscribes :create, resources(:package => node['mongodb']['package_name'] ), :immediately
end

directory node['mongodb']['logpath'] do
  owner "mongodb"
  group "mongodb"
  mode 00755
  action :nothing
  subscribes :create, resources(:package => node['mongodb']['package_name'] ), :immediately
end

