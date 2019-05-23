#!/bin/sh

#creates the gatling dir where gatling repos should be stored
#future updates will give nginx access to this directory to that results can be access via the web
#This specifically does chown and chgrp because a bug in bolt forces this task to be run as root. BOLT-1336

instance_username="$PT_instance_username"
if [ -z "${instance_username}" ] ; then
  instance_username="tester"
fi
export gatling_dir="/home/$instance_username/gatling"
if [ ! -d $gatling_dir ]; then
  mkdir -p $gatling_dir
  chown -R $instance_username $gatling_dir
  chgrp -R $instance_username $gatling_dir
fi

if [ ! -d $gatling_dir/gatling-puppet-load-test ]; then 
  git clone https://github.com/puppetlabs/gatling-puppet-load-test.git /home/$instance_username/gatling/gatling-puppet-load-test
  chown -R $instance_username /home/$instance_username/gatling/gatling-puppet-load-test
  chgrp -R $instance_username /home/$instance_username/gatling/gatling-puppet-load-test
fi
