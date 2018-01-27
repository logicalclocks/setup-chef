



# 1. Use 'netstat -lptn' to check if services are running on port: 80, 8080, 443, 8181, 50700, etc ...

# 2. Check that /srv/hops is writable and empty. Create it, make it owned by root with permissions '755'
  
# 3. Get available disk space ( df -kh) for each hard-disk, get #cpus per host, get 'free -m' for each host.

# 4. Check if there is a GPU installed on the machine (lspci -vnn | grep VGA -A 12)

# 5. Check if cuda is installed on the machine

# 6. Update the /etc/hosts on all servers to include all hosts

# 7. Ping all hosts to make sure they are reachable


bash "start_hops" do
  user "root"
  code <<-EOF
    echo "{ "#{node['host']}" : {" > /tmp/hops_start.hops
    rm -f /tmp/ping.hops
    touch /tmp/ping.hops
    echo "\"non_reachable}" : [" > /tmp/ping.hops        
  EOF
end

for n in node['setup']['default']['private_ips']
  bash "ping_host_#{n}" do
    user "root"
    code <<-EOF 
     ping -c 2 #{n}
     if [ $? -ne 0 ] ; then
        echo ",\"#{n}\"" > /tmp/ping.hops        
     fi
  EOF
  end
end 

bash "ping_finish" do
    user "root"
    code <<-EOF
# remove first comma (if one)
    line=$(cat "/tmp/ping.hops" | sed -e 's/,//')
    echo $line >
    echo "${line}]," > /tmp/ping.hops        
EOF
end


template "/home/#{node["setup"]["user"]}/.karamel/ports.sh" do
  source "ports.sh.erb"
  owner node["setup"]["user"]
  group node["setup"]["group"]
  mode 0710
end


bash "netstat_services" do
    user "root"
    code <<-EOF
    /home/#{node["setup"]["user"]}/.karamel/ports.sh
EOF
end

bash "hops_dirs" do
    user "root"
    code <<-EOF
    rm -f /tmp/dirs.hops
    if [ -d /srv/hops ] ; then
       echo " 'dirs_not_empty' : [ '/srv/hops']," > /tmp/dirs.hops
    fi
    EOF
end

bash "hops_dirs" do
    user "root"
    code <<-EOF
    rm -f /tmp/devices.hops
    devices=$(df -h | grep ^/ | tail -n +2)
    echo "'devices' : \"$devices\"," > /tmp/devices.hops
    EOF
end

bash "hops_cpus" do
    user "root"
    code <<-EOF
    rm -f /tmp/cpus.hops
    cpus=$(cat /proc/cpuinfo | grep 'model name')
    echo "'cpus' : \"$cpus\"," > /tmp/cpus.hops
    EOF
end

bash "hops_mem" do
    user "root"
    code <<-EOF
    rm -f /tmp/mem.hops
    mem=$(free -m | head -2 | tail -n +2 | awk -F ' ' '{print $2}')
    echo "'mem' : \"$mem\"," > /tmp/mem.hops
    EOF
end


bash "hops_gpus" do
    user "root"
    code <<-EOF
    rm -f /tmp/gpus.hops
    gpus=$(lspci -vnn | grep VGA -A 12)
    echo "'gpus' : \"$gpus\"," > /tmp/gpus.hops
    EOF
end

bash "hops_cuda" do
    user "root"
    code <<-EOF
    rm -f /tmp/cuda.hops
    cuda=$(ndvidia-smi -L)
    echo "'cuda' : \"$cuda\"" > /tmp/cuda.hops
    EOF
end



bash "end_hops" do
  user "root"
  code <<-EOF
    cat /tmp/hops_start.hops > /tmp/hops.hops
    cat /tmp/ping.hops >> /tmp/hops.hops
    cat /tmp/dirs.hops >> /tmp/hops.hops
    cat /tmp/devices.hops >> /tmp/hops.hops
    cat /tmp/cpus.hops >> /tmp/hops.hops
    cat /tmp/mem.hops >> /tmp/hops.hops
    cat /tmp/gpus.hops >> /tmp/hops.hops
    cat /tmp/cuda.hops >> /tmp/hops.hops
    echo "}" >> /tmp/hops.hops
  EOF
end


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


setup_return "returning_report_from_node" do
  action: measure
end
