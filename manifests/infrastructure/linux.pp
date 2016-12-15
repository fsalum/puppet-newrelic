# == Class: newrelic::infrastructure::linux
#
class newrelic::infrastructure::linux {
  case $::osfamily {
    'Debian': {
      apt::source { 'newrelic-infra':
        location    => 'https://download.newrelic.com/infrastructure_agent/linux/apt',
        repos       => 'main',
        key         => {
          id  => 'A758B3FBCD43BE8D123A3476BB29EE038ECCE87C',
          key => 'https://download.newrelic.com/infrastructure_agent/gpg/newrelic-infra.gpg',
        },
        include     => {
          src => false,
        },
        release     => $::lsbdistcodename,
        architecure => 'amd64',
      }->

      package { 'newrelic-infra':
        ensure => installed,
      }
    }
    'RedHat': {
      exec { 'create-newrelic-infra-repo':
        command => join(['curl -o /etc/yum.repos.d/newrelic-infra.repo https://download.newrelic.com/infrastructure_agent/linux/yum/el/',
          $::operatingsystemmajrelease, '/x86_64/newrelic-infra.repo'], ''),
        path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
        creates => '/etc/yum.repos.d/newrelic-infra.repo',
      }->

      package { 'newrelic-infra':
        ensure => installed,
      }
    }
    default: {
      warning("Unsupported OS Family ${::osfamily}")
    }
  }
}
