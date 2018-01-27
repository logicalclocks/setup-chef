include_attribute "conda"
include_attribute "kagent"

default["install"]["dir"]                          = ""
default["install"]["user"]                         = ""
default["install"]["ssl"]                          = "false"
default["install"]["cleanup_downloads"]            = "false"
default["install"]["upgrade"]                      = "false"
default["install"]["addhost"]                      = "false"

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


default['setup']['default']['public_ips']          = ['']
default['setup']['default']['private_ips']         = ['']
