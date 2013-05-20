Deployment Pipeline
===================

The root directory for Avegas Deployment Pipelinne template

Structure
---------
tbd


Development Environment
-----------------------

### Install ###

To test the deployment pipeline on a set of virtual machines in your development environment you need to install:

* [Virtual box](https://www.virtualbox.org/wiki/Downloads)
* [Vagrant](http://docs.vagrantup.com/v2/installation/index.html)

and add a Ubuntu server box:

`$ vagrant box add precise64 http://files.vagrantup.com/precise64.box`

There is a script `setup-dev.sh` that do the above steps on a Ubuntu 12.10 machine:

`$ ./setup-dev.sh`

### Use ###

Setup and provision the machines:

`$ vagrant up`

Log in on the machines:

`$ vagrant ssh ci`
`$ vagrant ssh test`
`$ vagrant ssh prod`

See the [Vagrant documentation](http://docs.vagrantup.com/v2/) for more about handling the virtual machines.
