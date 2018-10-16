
package 'curl'

case node['platform_family']
when 'debian'
  apt_update 'update'
when 'rhel'
 Chef::Log.info "REDHAT !!!"
  execute 'yum_update_upgrade' do
   command 'sudo yum update -y'
  end
  yum_package 'openssl-libs'
end


if "#{node['setup']['nginx_skip']}" != "true"
  package 'openssl'
  node.override['nginx']['auth_request']['url'] = "#{node['download_url']}/nginx.tar.gz"
  node.override['nginx']['default_root'] = node['setup']['download_dir']
  node.override['nginx']['port'] = 1880
  include_recipe 'nginx::default'
end

def recursiveFlat(m)
  values = m.values
  ret_value = []
  values.each do |v|
    if v.instance_of? Hash
      ret_value << recursiveFlat(v)
    else
      ret_value << v
    end
  end
  ret_value
end

res = recursiveFlat(node)
res.values.each do |v|
  if v =~ /#{node['download_url']}/
    bash 'dump' do
      user 'root'
      code <<-EOH
        echo "#{v}" >> /tmp/urls
      EOH
    end
  end
end
