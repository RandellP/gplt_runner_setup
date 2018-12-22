
# p9_instance_setup

Welcome to your new module. A short overview of the generated parts can be found in the PDK documentation at https://puppet.com/pdk/latest/pdk_generating_modules.html .

The README template below provides a starting point with details about what information to include in your README.

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with p9_instance_setup](#setup)
    * [What p9_instance_setup affects](#what-p9_instance_setup-affects)
    * [Beginning with p9_instance_setup](#beginning-with-p9_instance_setup)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)

## Description

This module can configure a platform9 instance with the needed software to be able to run puppet perf simulations.

## Setup

### What p9_instance_setup affects **OPTIONAL**

By default this will set the new users shell to zsh

### Beginning with p9_instance_setup

In order to install `rehan-ohmyzsh`, run the following command:
```bash
$ puppet module install rehan-ohmyzsh
```
## Usage

The main usage is by running the bolt plan.  A normal platform9 instance doesn't have puppet on it, which bolt can handle.  The plan also will copy fog file, tmux.conf and .ssh files to the centos and new user account
As a module it will not copy config files, just install the needed software packages, and create the user.

```puppet
# As a module with default user of tester that will use zsh
inclde p9_instance_setup

# As module with user JoeBoo using bash
class { 'p9_instance_setup':
  test_user => "JoeBoo",
  set_zsh => false,
}

# It contains a bolt plan that allows use on p9 instances that are not agents

# To run the plan with defaults
bolt plan run p9_instance_setup::setup_instance --nodes <node> --run-as root --tty --user centos --private-key <access key>

# To run the plan with customer username
bolt plan run p9_instance_setup::setup_instance --nodes <node> --run-as root --tty --user centos --private-key <access key
> instance_username=JoeBoo
```
