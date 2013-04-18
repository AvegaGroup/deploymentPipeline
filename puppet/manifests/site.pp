# site.pp 
# Inspired by
# http://projects.puppetlabs.com/projects/puppet/wiki/Advanced_Puppet_Pattern
# define nodes
import "nodes.pp"

# The filebucket option allows for file backups to the server
filebucket { main: server => 'puppetmaster.hem.sennerholm.net' }

# Set global defaults - including backing up all files to the main filebucket and adds a global path
File { backup => main }