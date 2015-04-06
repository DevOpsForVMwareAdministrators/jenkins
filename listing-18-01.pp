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

node default {
  # This is where you can declare classes for all nodes.
  # Example:
  #   class { 'my_class': }
  include 'ntp'
}