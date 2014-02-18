Deployment Pipeline
===================

The root directory for Avegas Deployment Pipelinne template

Structure
---------
tbd


Development Environment
-----------------------

### Install ###

#### Pre-requisite git
The environment setup files are stored on github and you need git to clone the repository.

Attention: The Mac version of the install script assumes that [MacPorts](http://www.macports.org/) is installed.

You find installation instructions for git on [github](https://help.github.com/articles/set-up-git).

Clone this repository into a folder of choice
`$ git clone https://github.com/AvegaGroup/deploymentPipeline.git`

To test the deployment pipeline on a set of virtual machines in your development environment you need to install:

* [Virtual box](https://www.virtualbox.org/wiki/Downloads)
* [Vagrant](http://docs.vagrantup.com/v2/installation/index.html)

and add a Ubuntu server box: (Hopefully not needed anymore)

`$ vagrant box add precise64 http://files.vagrantup.com/precise64.box`

NOTE! ONLY FOR Ubuntu: There is a script `setup-dev.sh` that do the above steps on a Ubuntu 12.04 LTS and 12.10 machine:

`$ ./setup-dev.sh`

### Use ###

Setup and provision the machines 
NOTE! Make sure that you are in the root directory of your Git image when running the following commands.

`$ vagrant up`

Log in on the machines:

`$ vagrant ssh ci`
`$ vagrant ssh test`
`$ vagrant ssh prod`

See the [Vagrant documentation](http://docs.vagrantup.com/v2/) for more about handling the virtual machines.
