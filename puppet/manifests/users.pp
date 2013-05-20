# Defines users
# http://docs.puppetlabs.com/references/stable/type.html#user
# Ugly solutions with a different file, how to ensure that the "password" field doesn't get public?

group { "admin":
  ensure     => present,
}

group { "devel":
  ensure     => present,
}


group { "mikan":
  ensure     => present,
}
user { "mikan":
  ensure     => present,
  comment    => "Mikael Sennerholm",
  gid        => mikan,
  managehome => true,
  groups     => [admin,devel],
  password   => '$6$701V7V8c$qh3oAdvtaRykkBDMeZQYJEUJ/RFRpEF2G0WXOdIcH4ZW1OQi6IGEbS6..bosxrz06hgyDTQ9iNphBE/LT9D64/'
}

group { "jelmstrom":
  ensure     => present,
}
user { "jelmstrom":
  ensure     => present,
  comment    => "Johan Elmstrom",
  managehome => true,
  gid        => jelmstrom,
  groups     => devel,
  password   => '6$qC8NJcOq$0pqP3pXWtQ2fQjlxEw0o.6ISe2O27ruyHG1C4sDFiCw9wOSY/8Cq7ky4FKGOsnvCAqE1Ue.T.WkBa/O90AfD81'
}
 

group { "dfroding":
  ensure     => present,
}
user { "dfroding":
  ensure     => present,
  comment    => "Daniel Fröding",
  gid        => dfroding,
  groups     => devel,
  managehome => true
}

group { "dfagerstrom":
  ensure     => present,
}
user { "dfagerstrom":
  ensure     => present,
  comment    => "Daniel Fagerström",
  gid        => dfagerstrom,
  groups     => devel,
  managehome => true
}