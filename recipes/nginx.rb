package 'wget'

case node['platform_family']
when 'rhel'
  package 'openssl-libs'
end

if "#{node['setup']['nginx']['skip']}" != "true"
  package 'openssl'
  node.override['nginx']['auth_request']['url'] = "#{node['download_url']}/nginx.tar.gz"
  node.override['nginx']['default_root'] = node['setup']['nginx']['download_dir']
  node.override['nginx']['port'] = node['setup']['nginx']['port']
  include_recipe 'nginx::default'
end

directory node['setup']['nginx']['download_dir'] do
  owner "root"
  group "root"
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
    bash "download-#{v}" do
      user node['nginx']['user']
      group node['nginx']['group']
      cwd node['setup']['nginx']['download_dir']
      code <<-EOH
        wget --mirror --no-parent -X "*" --reject "index.html*" -e robots=off --no-host-directories #{v}
      EOH
    end
  end
end
