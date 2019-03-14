plan p9_instance_setup::setup_instance (
     TargetSpec $nodes,
     String $instance_username = "tester",
     Boolean $set_zsh = false,
   ) {


  $result_whoami = run_command('whoami',"localhost",'_catch_errors' => true)
  $running_user = $result_whoami.first.value[stdout].strip
#  notice("Using running bolt is $running_user")

  $result_pwd = run_command('echo $HOME',"localhost",'_catch_errors' => true)
  $home_dir = $result_pwd.first.value[stdout].strip
#  notice("home_dir is $home_dir")

  # Install the puppet-agent package if Puppet is not detected.
  # Copy over custom facts from the Bolt modulepath.
  # Run the `facter` command line tool to gather node information.
  $nodes.apply_prep

  # Compile the manifest block into a catalog
  apply($nodes,_catch_errors => true) {
    class { 'p9_instance_setup':
      test_user => $instance_username,
      set_zsh => $set_zsh,
    }
  }

  upload_file("$home_dir/.fog","/home/centos/.fog",$nodes)
  upload_file("$home_dir/.fog","/home/$instance_username/.fog",$nodes)
  upload_file("$home_dir/.tmux.conf","/home/centos/.tmux.conf",$nodes)
  upload_file("$home_dir/.tmux.conf","/home/$instance_username/.tmux.conf",$nodes)
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

  run_command("cp /home/centos/ssh_temp/* /home/centos/.ssh/",$nodes)
  run_command("cp -p /home/centos/ssh_temp/* /home/$instance_username/.ssh/",$nodes)

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
      path  => "/home/$instance_username/.fog",
      owner => "$instance_username",
      group => "$instance_username",
    }
    file { 'user tmux.conf':
      path  => "/home/$instance_username/.tmux.conf",
      owner => "$instance_username",
      group => "$instance_username",
    }
    file { 'user ssh':
      path  => "/home/$instance_username/.ssh",
      owner => "$instance_username",
      group => "$instance_username",
      recurse => true,
    }
  }

  run_task('p9_instance_setup::setup_metrics_viewer', $nodes, instance_username=> $instance_username)

}
