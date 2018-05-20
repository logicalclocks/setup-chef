
group node['nginx']['group'] do
 action :create
 not_if "getent group #{node['nginx']['group']}"
end

user node['nginx']['user'] do
  home "/home/#{node['nginx']['user']}"
  gid node['nginx']['group']
  action :create
  shell "/bin/bash"
  manage_home true
  not_if "getent passwd #{node['nginx']['user']}"
end

group node['nginx']['group'] do
  action :modify
  members ["#{node['nginx']['user']}"]
  append true
end
