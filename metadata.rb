maintainer       "Jim Dowling"
maintainer_email "jim@logicalclocks.com"
name             "setup"
license          "AGPL 3.0"
description      "Installs/Configures the Setup cookbook used by Hops"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.3.0"
source_url       "https://github.com/logicalclocks/setup-chef"


%w{ ubuntu debian centos }.each do |os|
  supports os
end

depends 'kagent'
depends 'conda'
depends 'poise-python'
depends 'openssl'
depends 'sudo'
depends 'hostsfile'
depends 'ntp'
depends 'poise-python'
depends 'magic_shell'


recipe "setup::install", "Fixes /etc/hosts and pings for connectivitiy"
recipe "setup::default", "Checks memory, diskspace, returns a report to Karamel"
recipe "setup::cuda", "Installs and configures cuda"
recipe "setup::nginx", "Installs and configures nginx to host installation files"
recipe "setup::purge", "Deletes cuda and everything else"


attribute "install/dir",
          :description => "Default ''. Set to a base directory under which all hops services will be installed.",
          :type => "string"

attribute "install/user",
          :description => "User to install the services as",
          :type => "string"

attribute "install/upgrade",
          :description => "User to upgrade the software",
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

attribute "cuda/user",
          :description => "Username to run cuda as",
          :type => 'string'

attribute "cuda/group",
          :description => "group to run cuda as",
          :type => 'string'

attribute "cuda/dir",
          :description => "Installation directory for cuda",
          :type => 'string'

attribute "setup/default/private_ips",
          :description =>  "Ips for the hosts",
          :type => 'array'
