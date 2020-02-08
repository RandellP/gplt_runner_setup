#!/bin/sh

#creates git dir for storing non-gatling git repos
#clones the puppet-metrics-collector for use loading the influx db of puppet-metrics-dashboard
#This specifically does chown and chgrp because a bug in bolt forces this task to be run as root. BOLT-1336

instance_username="$PT_instance_username"
if [ -z "${instance_username}" ] ; then
  instance_username="tester"
fi
export git_dir="/home/$instance_username/git"
if [ ! -d $git_dir/puppet-metrics-collector ]; then 
  git clone https://github.com/puppetlabs/puppetlabs-puppet_metrics_collector.git /home/$instance_username/git/puppet-metrics-collector
  chown -R $instance_username /home/$instance_username/git/puppet-metrics-collector
  chgrp -R $instance_username /home/$instance_username/git/puppet-metrics-collector
fi
