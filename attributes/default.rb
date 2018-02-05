include_attribute "conda"
include_attribute "kagent"
include_attribute "ndb"
include_attribute "hadoop_spark"
include_attribute "flink"
include_attribute "elastic"
include_attribute "zeppelin"
include_attribute "glassfish"
include_attribute "kkafka"
include_attribute "kzookeeper"
include_attribute "drelephant"
include_attribute "dela"
include_attribute "hive2"
include_attribute "hopsworks"
include_attribute "kkafka"
include_attribute "kzookeeper"


default["install"]["dir"]                          = ""
default["install"]["user"]                         = ""
default["install"]["ssl"]                          = "false"
default["install"]["cleanup_downloads"]            = "false"
default["install"]["upgrade"]                      = "false"
default["install"]["addhost"]                      = "false"
default["install"]["hostname_prefix"]              = "hops"

node.default["download_url"]                       = "http://193.10.67.171/hops"

# Default values for configuration parameters
default["cuda"]["version"]                         = "0.1.0"
default["cuda"]["user"]                            = node["install"]["user"].empty? ? "cuda" : node["install"]["user"]
default["cuda"]["group"]                           = node["install"]["user"].empty? ? "cuda" : node["install"]["user"]
default["cuda"]["certs_group"]                     = "certs"


default["cuda"]["dir"]                             = node["install"]["dir"].empty? ? "/var/lib" : node["install"]["dir"]
default["cuda"]["base_dir"]                        = "#{node["cuda"]["dir"]}/cuda"
default["cuda"]["home"]                            = "#{node["cuda"]["dir"]}/cuda-#{node["cuda"]["version"]}"

default["kagent"]["enabled"]                       = "false"


default["setup"]["user"]                           = "vagrant"
default['setup']['default']['public_ips']          = ['']
default['setup']['default']['private_ips']         = ['']
