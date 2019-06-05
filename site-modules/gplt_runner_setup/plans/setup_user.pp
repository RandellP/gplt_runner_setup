# Entry point for setting up a user. Creates and configures the user
#
# options:
#   instance_username - name of user to setup
#   set_zsh - if true sets the user shell to zsh
#   upload_user_files - if true attempts to upload user configuration files
#
# examples:
#   run_plan(gplt_runner_setup::setup_user,"nodes" => $nodes, "instance_username" => $username, "set_zsh" => $set_zsh,
#     "upload_user_files" => $upload_user_files)
#
#   bolt plan run gplt_runner_setup::setup_user --nodes 10.234.0.19 --user centos
#     --private-key ~/.ssh/id_rsa-acceptance --no-host-key-check --tty --run-as root instance_username=betty
#
plan gplt_runner_setup::setup_user (
    TargetSpec $nodes,
    String $instance_username = "",
    Boolean $set_zsh = true,
    Boolean $upload_user_files = true,
  ) {

  $username = run_plan(gplt_runner_setup::determine_username,"nodes" => "localhost",
    instance_username => $instance_username)
  notice("Username will be ${username}")

  $result_pwd = run_command('echo $HOME',"localhost","_catch_errors" => true)
  $home_dir = $result_pwd.first.value[stdout].strip

  # Install the puppet-agent package if Puppet is not detected.
  # Copy over custom facts from the Bolt modulepath.
  # Run the `facter` command line tool to gather node information.
  $nodes.apply_prep

  apply($nodes) {
    class { "gplt_runner_setup::user_setup":
      test_user => $username,
    }
  }

  if $set_zsh {
    apply($nodes) {
      class { "gplt_runner_setup::ohmyzsh":
        test_user => $username,
      }
    }
  }

  run_plan(gplt_runner_setup::upload_auth_files,"nodes" => $nodes, instance_username => $username)
  if $upload_user_files {
    run_plan(gplt_runner_setup::upload_user_files,"nodes" => $nodes, instance_username => $username)
  }

  #do not try to use _run_as => $username...  For some reason it claims it works but doesn't.
  #the tasks chown and chgrp anyway
  run_task("gplt_runner_setup::setup_metrics_viewer", $nodes, instance_username => $username)
  run_task("gplt_runner_setup::setup_gatling", $nodes, instance_username => $username)
}
