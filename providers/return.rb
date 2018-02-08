action :measure do

  contents = ::IO.read("/tmp/hops.hops")
  raise if contents.empty?

  kagent_param "/home/#{node['setup']['user']}/.karamel" do
    executing_cookbook "setup"
    executing_recipe node['fqdn']
    cookbook "setup"
    recipe "default"
    param "#{node['fqdn']}"
    value  "#{contents}"
  end

end


action :hostname do

  # https://www.itzgeek.com/how-tos/linux/centos-how-tos/change-hostname-in-centos-7-rhel-7.html
  my_ip = #{new_resource.my_ip}
  idx = #{new_resource.idx}
  bash "change_hostname" do
    user "root"
    code <<-EOF
      set -e
      # This changes both the 'static' and 'transient' hostname
      hostnamectl set-hostname "#{node['install']['hostname_prefix']}#{idx}"
   EOF
  end

end


