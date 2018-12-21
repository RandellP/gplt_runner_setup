# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include set_zsh
class p9_instance_setup::set_zsh (
  String $test_user = "tester",
  ) {

  ohmyzsh::install { $test_user: 
    set_sh => true,
  }
  ohmyzsh::plugins { $test_user: plugins => ['git', 'history', 'vi-mode'] }
}
