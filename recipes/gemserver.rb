
case node['platform_family']
when "debian"
  bash "chefdk-install-debian" do
    user "root"
    code <<-EOH
        cd /tmp
        yum install wget -y
        wget -nc #{node['download_url']}/#{node['setup']['chefdk']['debian']}
        apt install #{node['setup']['chefdk']['debian']} -y
      EOH
  end

when "rhel"
  bash "chefdk-install-rhel" do
    user "root"
    code <<-EOH
        cd /tmp
        yum install wget -y
        wget -nc #{node['download_url']}/#{node['setup']['chefdk']['rhel']}
        yum install -y #{node['setup']['chefdk']['rhel']} 
      EOH
  end

end


bash "start-gem-server" do
  user "root"
  code <<-EOH
      set -e
      if [ ! -d #{node['setup']['gemserver']['version']} ] ; then
         echo "Wrong gem server version. Set the correct attribute value for: setup/gemserver/version" 
         echo "Check in "ls /opt/chefdk/embedded/lib/ruby/gems/"
         exit 5
      fi
      nohup /opt/chefdk/embedded/bin/gem server --dir --port 12345 /opt/chefdk/embedded/lib/ruby/gems/#{node['setup']['gemserver']['version']}/gems &
      EOH
end
