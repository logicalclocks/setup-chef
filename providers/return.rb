action :measure do

 contents = ::IO.read("/tmp/")

 raise if contents.empty?

 /home/#{node['setup']['user']}/.karamel

 
kagent_param "/home/#{node['setup']['user']}/.karamel" do
   executing_cookbook "setup"
   executing_recipe node['host']
   cookbook "setup"
   recipe "default"
   param "node_report"
   value  "#{contents}"
end


end
