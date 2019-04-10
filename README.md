
# RandellP-p9_instance_setup

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with p9_instance_setup](#setup)
    * [What p9_instance_setup affects](#what-p9_instance_setup-affects)
    * [Beginning with p9_instance_setup](#beginning-with-p9_instance_setup)
3. [Usage - Configuration options and additional functionality](#usage)

## Description

This module can configure a platform9 instance with the needed software to be able to run puppet perf simulations.

## Setup

### What p9_instance_setup affects

By default this will set the new users shell to zsh

### Beginning with p9_instance_setup

This module has not been published to the forge.  Use bolt to install it via
the `bolt puppetfile install` command:
```bash
git clone https://github.com/RandellP/p9_instance_setup
cd p9_instance_setup
bolt puppetfile install
```

## Usage

The main usage is by running the bolt plan.  A normal platform9 instance doesn't have puppet on it, which bolt can handle.  The plan also will copy fog file, tmux.conf and .ssh files to the centos and new user account
As a module it will not copy config files, just install the needed software packages, and create the user.

### Via Puppet
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
access.  The plan will fail if the files copied during the plan do not exist
on the local machine.

1. Ensure that you have ssh access to the Centos host via the `centos` user.
1. Ensure that the `centos` user has `sudo` access.
1. Ensure that the following exist:
```
touch $HOME/.fog
touch $HOME/.ssh
touch $HOME/.tmux.conf
```

#### Run the Plan
To run the plan with defaults
```
bolt plan run p9_instance_setup::setup_instance --nodes <node> --run-as root --tty --user centos --private-key <access key> --modulepath ./modules
```

To run the plan with custom username
```
bolt plan run p9_instance_setup::setup_instance --nodes <node> --run-as root --tty --user centos --private-key <access key>  --modulepath ./modules instance_username=JoeBoo
```

## Current Oddness

First, I have never tested using this in any way other than with the bolt plan.  So YMMV classifing a node this way.

The bolt plan does some funny stuff... It applys the code in subsets. That is because when I tried doing it all at once the ohmyzsh module had trouble setting the shell on a user that was created in the same code.  So I did the code that created the user in one bolt apply, then did the ohmyzsh in another.  The dashboard stuff was split out because at one point I had to run it twice to get it to work.  But that got fixed, so it could really be merged back to the core at some future point. 

