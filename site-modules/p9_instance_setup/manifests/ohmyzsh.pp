# Install ohmyzsh, zsh, and set the users shell to zsh
#
# @summary Install and set the users shell to zsh
#
# @example
#   include p9_instance_setup::ohmyzsh
class p9_instance_setup::ohmyzsh (
  String $test_user = "tester",
  ) {

  ohmyzsh::install { [$test_user]:
    set_sh  => true,
  }

}
