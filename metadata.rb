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
recipe "setup::purge", "Deletes cuda and everything else"


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
