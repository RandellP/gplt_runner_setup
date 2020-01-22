#  Uploads authentication files known to be needed for running performance testing workflows
#
#  options:
#   instance_username - name of user to setup
#
#  examples:
#    run_plan(gplt_runner_setup::upload_auth_files,"nodes" => $nodes, instance_username => $username)
#
#    bolt plan run gplt_runner_setup::upload_auth_files --nodes 10.234.0.19 --user centos
#      --private-key ~/.ssh/id_rsa-acceptance --no-host-key-check --tty --run-as root instance_username=betty
#
plan gplt_runner_setup::upload_auth_files (
    TargetSpec $nodes,
    String $instance_username = "",
  ) {

  $username = run_plan(gplt_runner_setup::determine_username,"nodes" => "localhost",
    instance_username => $instance_username)
  notice("Username will be ${username}")

  $result_pwd = run_command('echo $HOME',"localhost","_catch_errors" => true)
  $home_dir = $result_pwd.first.value[stdout].strip

  # abs, vmpooler, aws account access 
  $fog_file_src = "${home_dir}/.fog"
  $fog_file_dest = "/home/${username}/.fog"
  # readable is a copy of a function in bolt 1.21 and later.  Can switch when we move to the latest bolt
  if gplt_runner_setup::readable($fog_file_src) {
    upload_file($fog_file_src,$fog_file_dest,$nodes,"_run_as" => $username)
  }

  # for aws s3 access
  $aws_cred_file_src = "${home_dir}/.aws/credentials"
  $aws_cred_file_dest = "/home/${username}/.aws/credentials"
  # readable is a copy of a function in bolt 1.21 and later.  Can switch when we move to the latest bolt
  if gplt_runner_setup::readable($aws_cred_file_src) {
    run_command("mkdir -p /home/${username}/.aws",$nodes,"_run_as" => $username)
    upload_file($aws_cred_file_src,$aws_cred_file_dest,$nodes,"_run_as" => $username)
  }
  $aws_config_file_src = "${home_dir}/.aws/config"
  $aws_config_file_dest = "/home/${username}/.aws/config"
  # readable is a copy of a function in bolt 1.21 and later.  Can switch when we move to the latest bolt
  if gplt_runner_setup::readable($aws_config_file_src) {
    run_command("mkdir -p /home/${username}/.aws",$nodes,"_run_as" => $username)
    upload_file($aws_config_file_src,$aws_config_file_dest,$nodes,"_run_as" => $username)
  }

  #private a public keys needed to login to vmpooler, aws, and other p9 instances
  $ssh_src = "${home_dir}/.ssh"
  $ssh_dest = "/home/${username}/ssh_temp"
  # readable is a copy of a function in bolt 1.21 and later.  Can switch when we move to the latest bolt
  if gplt_runner_setup::readable($ssh_src) {
    run_command("rm -rf ${ssh_dest}",$nodes)
    upload_file($ssh_src,$ssh_dest,$nodes,"_run_as" => $username)
    run_command("bash -c \"cp -rp ${ssh_dest}/* /home/${username}/.ssh/\"",$nodes,"_run_as" => $username)
    run_command("rm -rf ${ssh_dest}",$nodes)
  }
}
