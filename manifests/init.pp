# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include p9_instance_setup
class p9_instance_setup (
  String $test_user = "tester",
  Boolean $set_zsh = true,
  ) {

  create_resources( 'p9_instance_setup::core', $test_user)
  create_resources( 'p9_instance_setup::ohmyzsh', $test_user)
  create_resources( 'p9_instance_setup::dashboard')
  
}
