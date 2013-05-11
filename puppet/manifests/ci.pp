# -*- mode: ruby -*-
# vi: set ft=ruby :

include "jdk7"
include "jenkins"

jenkins::plugin {
  "git": ;
  "artifactory": ;
  "build-pipeline-plugin": ;
  "scm-sync-configuration": ;
}
