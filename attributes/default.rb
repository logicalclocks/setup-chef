include_attribute "conda"
include_attribute "kagent"
include_attribute "ndb"
include_attribute "hadoop_spark"
include_attribute "flink"
include_attribute "elastic"
include_attribute "glassfish"
include_attribute "kkafka"
include_attribute "kzookeeper"
include_attribute "drelephant"
include_attribute "dela"
include_attribute "hive2"
include_attribute "hopsworks"
include_attribute "kkafka"
include_attribute "kzookeeper"
include_attribute "tensorflow"
include_attribute "livy"
include_attribute "hops"
include_attribute "hops_airflow"
include_attribute "consul"



default['install']['dir']                          = ""
default['install']['user']                         = ""
default['install']['ssl']                          = "false"
default['install']['cleanup_downloads']            = "false"
default['install']['addhost']                      = "false"
default['install']['hostname_prefix']              = "hops"

node.default['download_url']                       = "http://193.10.67.171/hops"

default['kagent']['enabled']                       = "false"

default['setup']['user']                           = node['install']['user'].empty? ? "vagrant" : node['install']['user']
default['setup']['new_user']                       = "hdp"
default['setup']['new_user_password']              = ""
default['setup']['default']['public_ips']          = ['']
default['setup']['default']['private_ips']         = ['']

default['setup']['nginx']['skip']                  = "false"
default['setup']['nginx']['download_dir']          = "/var/www/html"
default['setup']['nginx']['port']                  = "1880"

default['setup']['disable_nw_mgr']                 = "false"

