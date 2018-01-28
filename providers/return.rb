action :measure do

  contents = ::IO.read("/tmp/hops.hops")
  raise if contents.empty?

  kagent_param "/home/#{node['setup']['user']}/.karamel" do
    executing_cookbook "setup"
    executing_recipe node['fqdn']
    cookbook "setup"
    recipe "default"
    param "node_report"
    value  "#{contents}"
  end

end
