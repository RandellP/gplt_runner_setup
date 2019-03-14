#!/bin/sh

instance_username="$PT_instance_username"
if [ -z "${instance_username}" ] ; then
  instance_username="tester"
fi
export git_dir="/home/$instance_username/git"
if [ ! -d $git_dir/puppet-metrics-viewer ]; then 
  git clone https://github.com/puppetlabs/puppet-metrics-viewer.git /home/$instance_username/git/puppet-metrics-viewer
  chown -R $instance_username /home/$instance_username/git
fi
