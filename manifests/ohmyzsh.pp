# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include p9_instance_setup::ohmyzsh
class p9_instance_setup::ohmyzsh (
  String $test_user = "tester",
  ) {

  ohmyzsh::install { ["$test_user", "centos"]:
    set_sh  => true,
  }
  ohmyzsh::plugins { $test_user: plugins => ['git', 'history', 'vi-mode'] }
  ohmyzsh::plugins { centos: plugins => ['git', 'history', 'vi-mode'] }

}
