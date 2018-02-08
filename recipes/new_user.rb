homedir = "/home/#{node['setup']['new_user']}"

user node["setup"]["new_user"] do
  gid node["setup"]["new_user"]
  manage_home true
  home "#{homedir}"
  action :create
  shell "/bin/bash"
  not_if "getent passwd #{node['setup']['new_user']}"
end

group node["setup"]["new_user"] do
  action :modify
  members ["#{node['setup']['new_user']}"]
  append true
end

kagent_keys "#{homedir}" do
  cb_user "#{node['setup']['new_user']}"
  cb_group "#{node['setup']['new_user']}"
  cb_name "setup"
  cb_recipe "new_user"  
  action :get_publickey
end  
