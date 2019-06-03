# Main plan entry point.  Configures the instance and sets up the user.
#
# options:
#   instance_username - The username to create, default is the user running bolt
#   set_zsh - If true sets the users shell to zsh
#   upload_user_files - If true will attempt to upload common user configuration files
#
# examples:
#   bolt task run gplt_runner_setup::setup_metrics_viewer --nodes 10.234.0.19 --user centos
#   --private-key ~/.ssh/id_rsa-acceptance --no-host-key-check --tty --run-as root instance_username=fanny
#
plan gplt_runner_setup::setup_instance (
    TargetSpec $nodes,
    String $instance_username = "",
    Boolean $set_zsh = true,
    Boolean $upload_user_files = true,
  ) {

  $username = run_plan(gplt_runner_setup::determine_username,"nodes" => "localhost",
    instance_username => $instance_username)
  notice("Username will be ${username}")

  run_plan(gplt_runner_setup::manage_software,"nodes" => $nodes)
  run_plan(gplt_runner_setup::setup_user,"nodes" => $nodes, "instance_username" => $username, "set_zsh" => $set_zsh,
    "upload_user_files" => $upload_user_files)
}
