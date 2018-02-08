homedir = "/home/#{node['setup']['new_user']}"

group node["setup"]["new_user"] do
  action :create
  not_if "getent group #{node['setup']['new_user']}"
end

user node["setup"]["new_user"] do
  gid node["setup"]["new_user"]
  manage_home true
  home "#{homedir}"
  action :create
  shell "/bin/bash"
  password node['setup']['new_user_password']  
#  not_if "getent passwd #{node['setup']['new_user']}"
end

group node["setup"]["new_user"] do
  action :modify
  members ["#{node['setup']['new_user']}"]
  append true
end

sudo node['setup']['new_user'] do
  user "%#{node['setup']['new_user']}"
end

kagent_keys "#{homedir}" do
  cb_user node['setup']['new_user']
  cb_group node['setup']['new_user']
  action :generate  
end  

kagent_keys "#{homedir}" do
  cb_user 
  cb_group node['setup']['new_user']
  cb_name "setup"
  cb_recipe "master"  
  action :return_publickey
end  

bash "enable_ssh_into_myself" do
  user node['setup']['new_user']
  code <<-EOF
     cp #{homedir}/.ssh/id_rsa.pub #{homedir}/.ssh/authorized_keys
  EOF
  not_if { ::File.exists?("#{homedir}/.ssh/authorized_keys") }
end

