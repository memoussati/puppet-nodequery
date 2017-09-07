# == Class: nodequery
#
# Installs the Nodequery Agent.
#
# === Parameters
#
# [*token*]
#   Your Nodequery token
#   Generated when you create a server in the control panel
#
# === Examples
#
#  class { 'nodequery':
#    token  => "TOKENHERE",
#  }
#
# === Authors
#
# Ben Speakman ben@3sq.re
#
# === Copyright
#
# Copyright 2015 Ben Speakman
#
class nodequery (
  $token,
) {

  validate_string($token)

  user { 'nodequery':
    ensure => 'present',
    home   => '/etc/nodequery',
    shell  => '/bin/false',
    system => true
  }

  file { '/etc/nodequery':
    ensure  => 'directory',
    owner   => 'nodequery',
    group   => 'nodequery',
    mode    => '0700',
    require => User['nodequery'],
  }

  exec { 'retrieve_agent':
    command => 'wget -nv -o /dev/stdout -O /etc/nodequery/nq-agent.sh --no-check-certificate https://raw.github.com/nodequery/nq-agent/master/nq-agent.sh',
    path    => '/usr/local/bin:/bin:/usr/bin',
    creates => '/etc/nodequery/nq-agent.sh',
    require => [
        File['/etc/nodequery']
    ]
  }

  file { '/etc/nodequery/nq-agent.sh':
    owner   => 'nodequery',
    group   => 'nodequery',
    mode    => '0700',
    require => Exec['retrieve_agent'],
  }

  file { '/etc/nodequery/nq-auth.log':
    owner   => 'nodequery',
    group   => 'nodequery',
    mode    => '0700',
    content => $token,
    require => File['/etc/nodequery']
  }

  cron { 'nodequery':
    command => 'bash /etc/nodequery/nq-agent.sh > /etc/nodequery/nq-cron.log 2>&1',
    user    => 'nodequery',
    minute  => '*/3',
    require => User['nodequery'],
  }

}
