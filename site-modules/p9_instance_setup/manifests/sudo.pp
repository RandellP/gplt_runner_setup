# Configure the sudo module to not purge existing sudo users, and ensure the centos has passwordless sudo rights
#
# @summary Configure sudo module and centos privlidges
#
# @example
#   include p9_instance_setup::core
class p9_instance_setup::sudo (
  ) {

  class { "sudo":
    purge => false,
  }
  sudo::conf { "centos":
    priority => 50,
    content  => "centos ALL=(ALL) NOPASSWD: ALL",
  }
}
