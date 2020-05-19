maintainer       "Jim Dowling"
maintainer_email "jim@logicalclocks.com"
name             "setup"
license          "AGPL 3.0"
description      "Installs/Configures the Setup cookbook used by Hops"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.4.0"
source_url       "https://github.com/logicalclocks/setup-chef"


%w{ ubuntu centos }.each do |os|
  supports os
end

depends 'nginx', '= 9.0.0'
depends 'sudo', '~> 4.0.0'

depends 'hopsworks'
depends 'conda'
depends 'kagent'
depends 'hops'
depends 'ndb'
depends 'hadoop_spark'
depends 'flink'
depends 'livy'
depends 'tensorflow'
depends 'epipe'
depends 'dela'
depends 'kzookeeper'
depends 'kkafka'
depends 'elastic'
depends 'hopslog'
depends 'hopsmonitor'
depends 'glassfish'
depends 'hive2'
depends 'hops_airflow'
depends 'ulimit'
depends 'consul'
depends 'drelephant'
depends 'kube-hops'

recipe "setup::install", "Fixes /etc/hosts and pings for connectivitiy"
recipe "setup::default", "Checks memory, diskspace, returns a report to Karamel"
recipe "setup::nginx", "Installs and configures nginx to host installation files"
recipe "setup::new_user", "Installs a new user on all hosts"
recipe "setup::master", "Installs a new user on this host and puts its public key on  other hosts"
recipe "setup::purge", "Deletes cuda and everything else"


attribute "install/dir",
          :description => "Default ''. Set to a base directory under which all hops services will be installed.",
          :type => "string"

attribute "install/user",
          :description => "User to install the services as",
          :type => "string"

attribute "install/ssl",
          :description => "Is SSL turned on for all services?",
          :type => "string"

attribute "install/cleanup_downloads",
          :description => "Remove any zipped binaries that were downloaded and used to install services",
          :type => "string"

attribute "install/addhost",
          :description => "Indicates that this host will be added to an existing Hops cluster.",
          :type => "string"

attribute "install/hostname_prefix",
          :description => "Add all ips to the /etc/hosts file and give each hostname this prefix. Default is 'hops'.",
          :type => "string"

attribute "setup/user",
          :description => "User to install the services as",
          :type => "string"

attribute "setup/default/private_ips",
          :description =>  "Ips for the hosts",
          :type => 'array'

attribute "setup/disable_nw_mgr",
          :description =>  "Disable the NetworkManager service",
          :type => 'string'

attribute "setup/new_user",
          :description => "New user to install  as",
          :type => "string"

attribute "setup/new_user_password",
          :description => "New user password",
          :type => "string"

attribute "setup/nginx/download_dir",
          :description => "Dir to download binaries to",
          :type => "string"

attribute "setup/nginx/skip",
          :description => "True to skip nginx installation",
          :type => "string"

attribute "setup/nginx/port",
          :description => "Port on which nginx should listen",
          :type => "string"

