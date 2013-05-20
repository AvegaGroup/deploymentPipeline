from fabric.api import *
import time


#env.roledefs = {                                                               
#    'prod': ['labprod1', 'labprod2'],                                          
#    'test': ['labtest1'],                                                      
#}                                                                              

@task
def prod():
    env.hosts = ['prod1','prod2']

@task
def test():
    env.hosts = ['test1']

@task
def host_type():
    run('uname -s')
    run('hostname -f')


def get_version_number(build_number):
    file_name = "/tmp/%s/version.txt" % build_number
    for line in open(file_name).readlines():
	if "maven.version" in line:
	    return line.split('=')[1].strip()
	raise "Failed to parse maven.version from " + file_name

@task
def deploy_petclinic(build_number='61'):
    run('echo deploying pet clinic')
    version_number = get_version_number(build_number)

    artefact_base_name = "spring-petclinic-" + version_number 
    artefact_smoke = "spring-petclinic-" + version_number + "-smoketest.zip"
    artefact_war = "spring-petclinic-" + version_number + ".war"

    repo_url = "http://labci2:8080/artifactory/libs-release-local/org/springframework/samples/spring-petclinic/%(version_number)s/%(artefact_name)s"
    repo_war = repo_url % { "version_number" : version_number, "artefact_name" : artefact_war }
    repo_smoke = repo_url % { "version_number" : version_number, "artefact_name" : artefact_smoke }

    local_war = "/tmp/deploy-%s/petclinic.war" % build_number
    local_smoke = "/tmp/deploy-%s/smoketest.zip" % build_number

    remote_war = "/var/lib/tomcat7/webapps/petclinic.war"
    remote_smoke = "/tmp/deploy-%s/smoketest.zip" % build_number

    # creating local and remote temp directories
    local("mkdir /tmp/deploy-%s" % build_number)
    run("mkdir /tmp/deploy-%s" % build_number)

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
    remote_smoke_bin = '/tmp/deploy-%s/%s/%s' % (build_number, artefact_base_name, "smoketest.sh")
    run('unzip %s -d /tmp/deploy-%s' % (remote_smoke, build_number))
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
