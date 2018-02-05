apt_update 'update' if platform_family?('debian')

package 'curl'

include_recipe 'nginx::default'
