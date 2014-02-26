from fabric.api import *
import time
import tempfile

env.user='root'

#env.roledefs = {
#    'prod': ['prod1', 'labprod2'],
#    'test': ['labtest1'],
#}

@task
def prod():
    env.hosts = ['prod1']

@task
def test():
    env.hosts = ['test1']

@task
def host_type():
    run('uname -s')
    run('hostname -f')

@task
def deploy_petclinic(build_number=''):
    run('echo deploying pet clinic')

    artefact_base_name = "spring-petclinic-" + build_number
    artefact_smoke = "spring-petclinic-" + build_number + "-smoketest.zip"
    artefact_war = "spring-petclinic-" + build_number + ".war"

    repo_url = "http://ci1:8081/artifactory/libs-release-local/org/springframework/samples/spring-petclinic/%(build_number)s/%(artefact_name)s"
    repo_war = repo_url % { "build_number" : build_number, "artefact_name" : artefact_war }
    repo_smoke = repo_url % { "build_number" : build_number, "artefact_name" : artefact_smoke }

    local_temp=  tempfile.mkdtemp(prefix=build_number)
    local_war =  "%s/petclinic.war" % local_temp
    local_smoke = "%s/smoketest.zip" % local_temp

    remote_war = "/var/lib/tomcat7/webapps/petclinic.war"
    remote_smoke = "%s/smoketest.zip" % local_temp

    # creating local and remote temp directories
    run("mkdir %s" % local_temp)

    # download artefacts
    run('echo Downloading artefacts')
    local("curl %s > %s" % (repo_war, local_war))
    local("curl %s > %s" % (repo_smoke, local_smoke))

    # deploy application
    run('service tomcat7 stop')
    waitForTomcatToDie()

    # clean tomcat
    run('rm -rf /var/lib/tomcat7/webapps/petclinic*')
    run('rm -rf /var/cache/tomcat7/*')

    put(local_war, remote_war)
    put(local_smoke, remote_smoke)

    # startup
    run('service tomcat7 start')
    waitForTomcatToStart()

    # run smoke test
    remote_smoke_bin = '%s/%s/%s' % (local_temp, artefact_base_name, "smoketest.sh")
    run('unzip %s -d %s' % (remote_smoke, local_temp))
    run('sudo chmod 777 %s' % (remote_smoke_bin))
    run(remote_smoke_bin)


def waitForTomcatToStart():
    while (True):
        with settings(warn_only=True):
            if run('grep "Server startup in" /var/log/tomcat7/catalina.out').failed:
                time.sleep(1)
            else:
                return


def waitForTomcatToDie():
    while(True):
        with settings(warn_only=True):
            if run('service tomcat7 status').failed:
                return
            else:
                time.sleep(1)
