
# contents = "
# { "#{node['host']}" : {
#      "non_reachable_hosts" : ["gpu1","hadoop2"],
#      "dirs_not_empty" : ["/srv/hops", "/disks/disk1"],                       
#      "busy_ports" : ['3306/mysqld','8080/httpd'],
#      "device_ids" : ['/dev/sdd','/dev/sda1','/dev/sda2'],
#      "device_capacities" : ['400GB','4TB','16TB'],  
#      "device_free" : ['200GB','3TB','16TB'],
#      "memory_available" : '256GB',  
#      "cpu_info" : 'Intel(R) Core(TM) i7-6820HQ CPU @ 2.70GHz',
#      "num_cpus" : 14,
#      "gpu_info" : '',
#      "num_gpus" : 10,
#      "cuda_installed" : "9.1"
#   }
# }"




# 0. Ping all hosts to make sure they are reachable

# 1. Use 'netstat -lptn' to check if services are running on port: 80, 8080, 443, 8181, 50700, etc ...

# 2. Check that /srv/hops is writable and empty. Create it, make it owned by root with permissions '755'
  
# 3. Get available disk space ( df -kh) for each hard-disk, get #cpus per host, get 'free -m' for each host.

# 4. Check if there is a GPU installed on the machine (lspci -vnn | grep VGA -A 12)

# 5. Check if cuda is installed on the machine

# 6. Update the /etc/hosts on all servers to include all hosts

# pretty print JSON utility
package 'jq'

if node['install']['addhost'].eql?("true")
  node[:setup][:default][:private_ips].each_with_index do |ip, index| 
    hostsfile_entry "#{ip}" do
      hostname  "#{node["install"]["hostname_prefix"]}#{index}"
      action    :create
      unique    true
    end
  end
end

bash "start_ping" do
  user "root"
  code <<-EOF
    rm -f /tmp/ping.hops
    touch /tmp/ping.hops
    echo "{ 'non_reachable' : [" > /tmp/ping.hops        
  EOF
end

#
# Ping all hosts
#

for n in node['setup']['default']['private_ips']
  bash "ping_host_#{n}" do
    user "root"
    code <<-EOF 
     ping -c 2 #{n}
     if [ $? -ne 0 ] ; then
        echo ",\"#{n}\"" >> /tmp/ping.hops        
     fi
  EOF
  end
end 

bash "ping_finish" do
    user "root"
    code <<-EOF
    line=$(cat /tmp/ping.hops | sed -e 's/,//')
    echo -n "${line}]," > /tmp/ping.hops        
EOF
end


template "/home/#{node["setup"]["user"]}/.karamel/ports.sh" do
  source "ports.sh.erb"
  owner node["setup"]["user"]
  group node["setup"]["group"]
  mode 0710
end

#
# Nestat to identify running services
#

bash "netstat_services" do
    user "root"
    code <<-EOF
    /home/#{node["setup"]["user"]}/.karamel/ports.sh
EOF
end


#
# Check install dirs are empty
#

bash "hops_dirs" do
    user "root"
    code <<-EOF
    rm -f /tmp/dirs.hops
    if [ -d /srv/hops ] ; then
       echo -n " 'dirs_not_empty' : [ '/srv/hops']," > /tmp/dirs.hops
    fi
    EOF
end

bash "hops_dirs" do
    user "root"
    code <<-EOF
    rm -f /tmp/devices.hops
    devices=$(df -h | grep ^/ | tail -n +2)
    echo -n "'devices' : \'$devices', " > /tmp/devices.hops
    EOF
end

#
# Check CPUs available
#

bash "hops_cpus" do
    user "root"
    code <<-EOF
    rm -f /tmp/cpus.hops
    cpus=$(cat /proc/cpuinfo | grep 'model name' | sed -e 's/.*: //g' | tail -1)
    echo -n "'cpus' : '$cpus', " > /tmp/cpus.hops
    num_cpus=$(cat /proc/cpuinfo | grep 'processor' | wc -l)
    echo -n "'num_cpus' : '$num_cpus', " >> /tmp/cpus.hops
    EOF
end

#
# Check Memory available
#

bash "hops_mem" do
    user "root"
    code <<-EOF
    rm -f /tmp/mem.hops
    mem=$(free -m | head -2 | tail -n +2 | awk -F ' ' '{print $2}')
    echo -n "'mem' : '$mem', " > /tmp/mem.hops
    EOF
end

#
# Check Gpus available
#

bash "hops_gpus" do
    user "root"
    code <<-EOF
    rm -f /tmp/gpus.hops
    gpus=$(lspci -vnn | grep VGA -A 12)
    echo -n "'gpus' : '$gpus', " > /tmp/gpus.hops
    EOF
end


#
# Check Cuda Installed?
#
bash "hops_cuda" do
    user "root"
    code <<-EOF
    rm -f /tmp/cuda.hops
    cuda=$(ndvidia-smi -L)
    echo -n "'cuda' : '$cuda'" > /tmp/cuda.hops
    EOF
end


#
# Create a JSON with results that will be downloaded to Karamel server in $HOME/.karamel
#

bash "end_hops" do
  user "root"
  code <<-EOF
    cat /tmp/ping.hops > /tmp/hops.hops
    cat /tmp/dirs.hops >> /tmp/hops.hops
    cat /tmp/devices.hops >> /tmp/hops.hops
    cat /tmp/cpus.hops >> /tmp/hops.hops
    cat /tmp/mem.hops >> /tmp/hops.hops
    cat /tmp/gpus.hops >> /tmp/hops.hops
    cat /tmp/cuda.hops >> /tmp/hops.hops
    echo -n " }" >> /tmp/hops.hops
    # JSON wants " (double quotes) not ' (single quotes)    
    perl -pi -e "s/'/\"/g" /tmp/hops.hops
    cat /tmp/hops.hops | jq > /tmp/hops.pretty
    mv -f /tmp/hops.pretty /hops/hops.hops
  EOF
end

setup_return "returning_report_from_node" do
  action :measure
end

