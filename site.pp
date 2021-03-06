
## site.pp ##

# This file (/etc/puppetlabs/puppet/manifests/site.pp) is the main entry point
# used when an agent connects to a master and asks for an updated configuration.
#
# Global objects like filebuckets and resource defaults should go in this file,
# as should the default node definition. (The default node can be omitted
# if you use the console and don't define any other nodes in site.pp. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.)

## Active Configurations ##

# PRIMARY FILEBUCKET
# This configures puppet agent and puppet inspect to back up file contents when
# they run. The Puppet Enterprise console needs this to display file contents
# and differences.

# Define filebucket 'main':
filebucket { 'main':
  server => 'puppetmaster.devops.local',
  path   => false,
}

# Make filebucket 'main' the default backup location for all File resources:
File { backup => 'main' }

# DEFAULT NODE
# Node definitions in this file are merged with node data from the console. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.

# The default node definition matches any node lacking a more specific node
# definition. If there are no other nodes in this file, classes declared here
# will be included in every node's catalog, *in addition* to any classes
# specified in the console for that node.

node 'puppetnode01.devops.local' {
  package { 'git':
     ensure => installed,
  }
  package { 'maven':
     ensure => installed,
  }
  class { 'jenkins':
    configure_firewall => false,
    plugin_hash => {
      'credentials' => { version => '1.9.4' },
      'ssh-credentials' => { version => '1.6.1' },
      'git-client' => { version => '1.8.0' },
      'scm-api' => { version => '0.2' },
      'git' => { version => '2.2.1' },
    }
  }
}

node 'puppetnode03.devops.local' {
  class { 'jenkins':
    configure_firewall => false,
  }
}

node default {
  # This is where you can declare classes for all nodes.
  # Example:
  #   class { 'my_class': }
  include 'ntp'
}
