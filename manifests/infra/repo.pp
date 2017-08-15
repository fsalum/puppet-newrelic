# == Class: newrelic::infra::repo
#
# Installs the required repository for NewRelic Infrastructure pages
#
# === Authors:
#
# Craig Watson <craig.watson@claranet.uk>
#
# === Copyright:
#
# Copyright Claranet
#
class newrelic::infra::repo {

  case $facts['os']['family'] {
    'RedHat' : {
      $require = Yumrepo['newrelic-infra']
      yumrepo { 'newrelic-infra':
        ensure        => 'present',
        descr         => 'New Relic Infrastructure',
        baseurl       => "http://download.newrelic.com/infrastructure_agent/linux/yum/el/${facts[operatingsystemmajrelease]}/x86_64",
        gpgkey        => 'http://download.newrelic.com/infrastructure_agent/gpg/newrelic-infra.gpg',
        gpgcheck      => '1',
        repo_gpgcheck => '1',
      }
    }

    'Debian' : {

      $require = Apt::Source['newrelic-infra']

      ensure_packages('apt-transport-https')

      ::apt::source { 'newrelic-infra':
        location => 'https://download.newrelic.com/infrastructure_agent/linux/apt',
        repos    => 'main',
        key      => {
          id  => 'A758B3FBCD43BE8D123A3476BB29EE038ECCE87C',
          key => 'https://download.newrelic.com/infrastructure_agent/gpg/newrelic-infra.gpg',
        },
        include  => {
          src => false,
        },
        release  => $facts['lsbdistcodename'],
        require  => Package['apt-transport-https'],
      }
    }

    default: {
      fail("Unknown osfamily: $facts[os][family]")
    }
  }
}
