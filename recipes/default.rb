package 'wget'

case node['platform_family']
when 'rhel'
  package 'openssl-libs'
end

directory node['setup']['download_dir'] do
  owner node['setup']['user']
  group node['setup']['group']
  recursive true
  action :create
end


def recursiveFlat(m)
  values = m.values
  ret_value = []
  values.each do |v|
    if v.is_a? Hash
      ret_value = ret_value | recursiveFlat(v)
    else
      ret_value << v
    end
  end
  ret_value
end

res = recursiveFlat(node)
res.each do |v|
  if v =~ /#{node['download_url']}.+/ || v =~ /https:\/\/repo.hops.works\/master\/.+/
    # want to match 'kube/docker-images/1.4.1 -  but not 'kube/docker-images/registry_image.tar'
    # if v =~ /kube\/docker-images\/[0-9]*.+/ && v =~ /#{node['install']['version']}.+/
    if v =~ /#{node['download_url']}\/kube\/docker-images\/.*/
      bash "download-kube-#{v}" do
        user node['setup']['user']
        group node['setup']['group']
        cwd node['setup']['download_dir']
        code <<-EOH
        wget --mirror --no-parent -X "*" -N --reject "index.html*" --accept-regex ".*kube\/docker-images\/#{node['install']['version']}\/*" -e robots=off --no-host-directories #{v}
      EOH
      end
    else
      bash "download-#{v}" do
        user node['setup']['user']
        group node['setup']['group']
        cwd node['setup']['download_dir']
        code <<-EOH
        wget --mirror --no-parent -X "*" -N --reject "index.html*" --reject-regex ".*kube\/docker-images\/[0-9]+.*" -e robots=off --no-host-directories #{v}
      EOH
      end
    end
    
  end
end
