# Install ohmyzsh, zsh, and set the users shell to zsh
#
# @summary Install and set the users shell to zsh
#
# @example
#   include gplt_runner_setup::ohmyzsh
class gplt_runner_setup::ohmyzsh (
  String $test_user = "tester",
  ) {

  ohmyzsh::install { [$test_user]:
    set_sh  => true,
  }

}
