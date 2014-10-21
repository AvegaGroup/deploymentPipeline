Deployment Pipeline
===================

OBS!!

Not updated any more, use:

https://github.com/AvegaGroup/dockerApplicationServer 

instead.

Sincerely
Mikael Sennerholm
20141021


Old info
-----------------------


This project will create ContiuousDelivery pipeline setup that you can run on a reasonably spec laptop.
It will create three virtual machines (which need 2GB RAM in total) that build, test, deploy and host the spring-petclinic application.


You can read more about the structure and the goals of the project on the [wiki] https://github.com/AvegaGroup/deploymentPipeline/wiki


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

#### Vagrant configuration

Vagrant has a lot to offer when it comes to handy plug-ins.

The following two should be installed before vagrant is used below:

    ` vagrant plugin install vagrant-vbguest
    ` vagrant plugin install vagrant-cachier

### Use ###

Setup and provision the machines 
NOTE! Make sure that you are in the root directory of your Git image when running the following commands.

`$ vagrant up`

Log in on the machines:

`$ vagrant ssh ci`
`$ vagrant ssh test`
`$ vagrant ssh prod`

See the [Vagrant documentation](http://docs.vagrantup.com/v2/) for more about handling the virtual machines.
