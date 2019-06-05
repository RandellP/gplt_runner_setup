# The core class manages the general software configuration that applies in all cases
#
# @summary Setup the software that is needed in all cases
#
# @example
#   include gplt_runner_setup::core
class gplt_runner_setup::core (
  ) {

  include ntp

  class { "timezone":
    timezone => "America/Los_Angeles",
  }

  #make it so we can login to root same as centos
  file { "root ssh authorized_keys":
    path    => "/root/.ssh/authorized_keys",
    source  => "/home/centos/.ssh/authorized_keys",
    replace => true,
  }

  # selinux was making it hard to access perf test results through ngnix
  class { "selinux":
    mode              => "permissive",
    module_build_root => "/opt/puppetlabs/puppet/cache",
  }
  class { "firewalld":
    default_zone => "trusted",
  }

  #configure sudo class and ensure centos has passwordless sudo privledges
  include gplt_runner_setup::sudo

  class { "tmux":
    ensure => true,
  }

  class { "rbenv": }
  rbenv::plugin { [ "rbenv/rbenv-vars", "rbenv/ruby-build" ]: }
  rbenv::build { "2.3.0": global => true }
  rbenv::gem { "beaker": ruby_version => "2.3.0" }

  # one small piece of gplt uses keystore from here.  Hopefully we can ditch that sometime in the future.
  class { "java" :
    package => "java-1.8.0-openjdk-devel",
  }

  include nginx

  include pdk

  include epel

  package { "python36-setuptools" :
    ensure      => "present",
  }
  package { "python36-devel" :
    ensure      => "present",
  }

  package { "puppet-bolt":
    ensure => "1.15.0-1.el7",
  }

  exec { "pip":
    command => "/usr/bin/easy_install-3.6 pip",
    require => [ Package["python36-setuptools"], Package["python36-devel"] ],
  }

  exec { "awscli":
    command => "/usr/local/bin/pip3 install awscli --upgrade",
    require => Exec["pip"],
  }
}
