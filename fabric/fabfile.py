from fabric.api import *


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

@task
def deploy_file(local_file="/dev/null"):
    put(local_file,'/tmp/installme.tgz')
    run('echo running my deploy command')

@task
def smoke():
    run('echo running smoketest')


