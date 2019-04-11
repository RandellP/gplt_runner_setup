plan p9_instance_setup::setup_instance (
     TargetSpec $nodes,
     String $instance_username = "testrunner",
     Boolean $set_zsh = true,
   ) {


  $result_whoami = run_command('whoami',"localhost",'_catch_errors' => true)
  $running_user = $result_whoami.first.value[stdout].strip
  if $instance_username == "testrunner" {
    $username = $running_user
  } else {
    $username = $instance_username
  }
  notice("User running bolt is $running_user")
  notice("Username will be $username")

  $result_pwd = run_command('echo $HOME',"localhost",'_catch_errors' => true)
  $home_dir = $result_pwd.first.value[stdout].strip
#  notice("home_dir is $home_dir")

  # Install the puppet-agent package if Puppet is not detected.
  # Copy over custom facts from the Bolt modulepath.
  # Run the `facter` command line tool to gather node information.
  $nodes.apply_prep

  # Compile the manifest block into a catalog
  apply($nodes) {
    class { 'p9_instance_setup::core':
      test_user => $username,
    }
    include p9_instance_setup::dashboard
  }

  if $set_zsh {
    apply($nodes) {
      class { 'p9_instance_setup::ohmyzsh':
        test_user => $username,
      }
    }
  }

  upload_file("$home_dir/.fog","/home/centos/.fog",$nodes)
  upload_file("$home_dir/.fog","/home/$username/.fog",$nodes)
  upload_file("$home_dir/.tmux.conf","/home/centos/.tmux.conf",$nodes)
  upload_file("$home_dir/.tmux.conf","/home/$username/.tmux.conf",$nodes)
  run_command("rm -rf /home/centos/ssh_temp",$nodes)
  upload_file("$home_dir/.ssh","/home/centos/ssh_temp",$nodes)

  apply($nodes) {
    file { 'centos ssh_temp':
      path  => '/home/centos/ssh_temp',
      owner => 'centos',
      group => 'centos',
      recurse => true,
    }
  }

  run_command("cp -r /home/centos/ssh_temp/* /home/centos/.ssh/",$nodes)
  run_command("cp -rp /home/centos/ssh_temp/* /home/$username/.ssh/",$nodes)
  run_command("rm -rf /home/centos/ssh_temp",$nodes)

  apply($nodes) {
    file { 'centos fog':
      path  => '/home/centos/.fog',
      owner => 'centos',
      group => 'centos',
    }
    file { 'centos tmux.conf':
      path  => '/home/centos/.tmux.conf',
      owner => 'centos',
      group => 'centos',
    }
    file { 'centos ssh':
      path  => '/home/centos/.ssh',
      owner => 'centos',
      group => 'centos',
      recurse => true,
    }
    file { 'user fog':
      path  => "/home/$username/.fog",
      owner => "$username",
      group => "$username",
    }
    file { 'user tmux.conf':
      path  => "/home/$username/.tmux.conf",
      owner => "$username",
      group => "$username",
    }
    file { 'user ssh':
      path  => "/home/$username/.ssh",
      owner => "$username",
      group => "$username",
      recurse => true,
    }
  }

  run_task('p9_instance_setup::setup_metrics_viewer', $nodes, instance_username=> $username)

}
