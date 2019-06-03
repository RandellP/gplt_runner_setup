# Upload user configuration files: tmux, zshrc, .aliases
#
# options:
#   instance_username - name of user to setup
#
# examples:
#   run_plan(p9_instance_setup::upload_user_files,"nodes" => $nodes, instance_username => $username)
#
#   bolt plan run p9_instance_setup::upload_user_files --nodes 10.234.0.19 --user centos
#     --private-key ~/.ssh/id_rsa-acceptance --no-host-key-check --tty --run-as root instance_username=betty
#
plan p9_instance_setup::upload_user_files (
    TargetSpec $nodes,
    String $instance_username = "",
  ) {

  $username = run_plan(p9_instance_setup::determine_username,"nodes" => "localhost",
    instance_username => $instance_username)
  notice("Username will be ${username}")

  $result_pwd = run_command('echo $HOME',"localhost","_catch_errors" => true)
  $home_dir = $result_pwd.first.value[stdout].strip


  $user_configs = [".tmux.conf", ".aliases", ".zshrc"]

  $user_configs.each |String $config| {
    $src = "${home_dir}/${config}"
    $dest = "/home/${username}/${config}"
    if p9_instance_setup::readable($src) {
      upload_file($src, $dest, $nodes, "_run_as" => $username)
    }
  }
}
