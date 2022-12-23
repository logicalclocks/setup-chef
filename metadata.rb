maintainer       "Jim Dowling"
maintainer_email "jim@logicalclocks.com"
name             "setup"
license          "AGPL 3.0"
description      "Installs/Configures the Setup cookbook used by Hops"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "3.1.0"
source_url       "https://github.com/logicalclocks/setup-chef"


%w{ ubuntu centos }.each do |os|
  supports os
end

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
depends 'kube-hops'
depends 'onlinefs'

recipe "setup::install", ""
recipe "setup::default", "Download distribution artifacts"

attribute "setup/user",
  :description => "User creating and downloading the distribution binaries. (Default: vagrant)",
          :type => "string"

attribute "setup/group",
  :description => "Group creating and downloading the distribution binaries. (Default: vagrant)",
          :type => "string"

attribute "setup/download_dir",
  :description => "Location where the distribution binaries will be downloaded. (Default: /home/vagrant/dist",
          :type => "string"

