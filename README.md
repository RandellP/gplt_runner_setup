
# RandellP-p9_instance_setup

#### Table of Contents

1. [Description](#description)
1. [Limitations](#limitations)
1. [What p9_instance_setup affects](#what-p9_instance_setup-affects)
1. [Usage - Configuration options and additional functionality](#usage)
    1. [Via Puppet](#via-puppet)
    1. [Via Bolt Plans](#via-bolt-plan)
        1. [Setup](#setup)
        1. [Plan Examples](#plan-examples)
            1. [Parameters](#Parameters)
            1. [Setup_instances](#setup_instances)
            1. [Manage_software](#manage_software)
            1. [Setup_user](#setup_user)
            1. [Upload_auth_files](#upload_auth_files)
            1. [Upload_user_files](#upload_user_files)

## Description

This module can configure a platform9 instance with the needed software to be able to run 
puppet perf simulations. It will also create and setup user(s) to be used for the same.

## Limitations

This module is only able to configue Centos instances.
This repo currently requires bolt version 1.15.x. You may need to downgrade your bolt installation to meet this requirement.

## What p9_instance_setup affects

By default it will create a user with the same name as the user that ran bolt.  It will set that
user's shell to zsh, and upload the user's auth and user configurations files.

Auth files uploaded: 
* .fog
* .aws/credentials
* .ssh/* (excluding authorized_keys)

User files
* uploaded: .tmux.conf
* .aliases
* .zshrc

## Usage

The normal usage is by running the bolt plan. As a module it will not upload anything, nor
 checkout any git repos for the user.  Module use has never been tested so YMMV.

### Via Puppet
Add the module and its dependencies to your puppet environment.
Include the module or use the class customizing the parameters.

```puppet
# As a module with default user of tester that will use zsh
include p9_instance_setup

# As module with user JoeBoo using bash
class { 'p9_instance_setup':
  test_user => "JoeBoo",
  set_zsh => false,
}
```

### Via Bolt Plan

#### Setup
The plan only supports Centos instances that have `centos` user with `sudo`
access.  

1. Ensure that you have ssh access to the Centos host via the `centos` user.
1. Ensure that the `centos` user has `sudo` access.

This module has not been published to the forge.  So clone the repo.  It has a lot of dependencies.
Use bolt to install them into the repo before first running.
```bash
git clone https://github.com/RandellP/p9_instance_setup
cd p9_instance_setup
bolt puppetfile install
```

#### Plan examples

#### Parameters
*not all plans take all of these*

* instance_username=<username> User to manage. Default is user running bolt
* set_zsh=<true|false> Set user shell to zsh. Default is true
* upload_user_files=<true|false> Upload user files. Default is true

#### setup_instances:
1. Manages the software.
1. Manages the user.
1. Uploads auth and user files.
1. Creates a git and gatling dir in the users home dir.
1. Clones the gatling_puppet_load_test repo into the gatling dir.
1. Clones the puppet-metrics-viewer into the git dir.

Parameters accepted: instance_username, set_zsh, upload_user_files
```
#with defaults
bolt plan run p9_instance_setup::setup_instance --nodes <node> --run-as root --tty --user centos --private-key <access key> 

#with custom username
bolt plan run p9_instance_setup::setup_instance --nodes <node> --run-as root --tty --user centos --private-key <access key> instance_username=JoeBoo

#without setting the user shell to zsh or copying up user files
bolt plan run p9_instance_setup::setup_instance --nodes <node> --run-as root --tty --user centos --private-key <access key> set_zsh=false upload_user_files=false
```

#### manage_software:
1. Manages the software.

Parameters accepted: None
```
bolt plan run p9_instance_setup::manage_software --nodes <node> --run-as root --tty --user centos --private-key <access key>
```

#### setup_user
1. Manages the user.
1. Uploads auth and user files. 
1. Creates a git and gatling dir in the users home dir.
1. Clones the gatling_puppet_load_test repo into the gatling dir.
1. Clones the puppet-metrics-viewer into the git dir.

Note: software must already be setup

Parameters accepted: instance_username, set_zsh, upload_user_files
```
#manage/create a user after the software is setup
bolt plan run p9_instance_setup::setup_user --nodes <node> --run-as root --tty --user centos --private-key <access key> instance_username=username
```

#### upload_auth_files
1. Uploads auth files.

Note: software must already be setup

Parameters accepted: instance_username
```
bolt plan run p9_instance_setup::upload_auth_files --nodes <node> --run-as root --tty --user centos --private-key <access key> instance_username=username
```

#### upload_user_files
1. Uploads user files.

Note: software must already be setup

Parameters accepted: instance_username
```
bolt plan run p9_instance_setup::upload_user_files --nodes <node> --run-as root --tty --user centos --private-key <access key> instance_username=username
```


