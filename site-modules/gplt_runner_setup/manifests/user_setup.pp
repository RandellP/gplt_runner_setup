# Creates user, sets up authorized_keys to accept the same as centos.  Creates a few useful directories that are part
# of the standard use model.  Configures passwordless sudo access for the user
#
# @summary Create and configure user
#
# @example
#   include gplt_runner_setup::user_setup
class gplt_runner_setup::user_setup (
  String $test_user = "tester",
  ) {

  user { $test_user:
    ensure           => "present",
    home             => "/home/${test_user}",
    password         => "!!",
    password_max_age => "99999",
    password_min_age => "0",
    shell            => "/bin/bash",
    managehome       => true,
  }

  file { "${test_user} ssh":
    ensure  => "directory",
    path    => "/home/${test_user}/.ssh",
    owner   => $test_user,
    group   => $test_user,
    mode    => "0700",
    recurse => true,
  }

  file { "${test_user} ssh_authorized_keys":
    path    => "/home/${test_user}/.ssh/authorized_keys",
    owner   => $test_user,
    group   => $test_user,
    source  => "/home/centos/.ssh/authorized_keys",
    mode    => "0600",
    require => File["${test_user} ssh"],
  }

  file { "${test_user} git":
    ensure => "directory",
    path   => "/home/${test_user}/git",
    owner  => $test_user,
    group  => $test_user,
  }

  file { "${test_user} gatling":
    ensure => "directory",
    path   => "/home/${test_user}/gatling",
    owner  => $test_user,
    group  => $test_user,
  }

  include gplt_runner_setup::sudo
  sudo::conf { $test_user:
    priority => 80,
    content  => "${test_user} ALL=(ALL) NOPASSWD: ALL",
  }

}
