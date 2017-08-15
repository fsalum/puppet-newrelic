# == Class: newrelic::legacy_repo
#
# Installs the required repository for NewRelic packages
#
# === Authors:
#
# Craig Watson <craig.watson@claranet.uk>
#
# === Copyright:
#
# Copyright Claranet
#
class newrelic::legacy_repo {

  case $facts['os']['family'] {
    'RedHat' : {
      $require = Package['newrelic-repo-5-3.noarch']
      package { 'newrelic-repo-5-3.noarch':
        ensure   => present,
        source   => 'http://yum.newrelic.com/pub/newrelic/el5/x86_64/newrelic-repo-5-3.noarch.rpm',
        provider => 'rpm',
      }
    }

    'Debian' : {
      $require = Apt::Source['newrelic']
      ::apt::source { 'newrelic':
        location => 'http://apt.newrelic.com/debian/',
        repos    => 'non-free',
        key      => {
          id  => 'B60A3EC9BC013B9C23790EC8B31B29E5548C16BF',
          key => 'https://download.newrelic.com/548C16BF.gpg',
        },
        include  => {
          src => false,
        },
        release  => 'newrelic',
      }
    }

    default: {
      fail("Unknown osfamily: $facts[os][family]")
    }
  }
}
