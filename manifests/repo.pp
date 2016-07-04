# == Class: newrelic::repo
#
# Mangage the new relic repo
#
# === Parameters
#
# manage_repo (bool) - True will install default apt/yum repo, false
# assumes you can manage the repository yourself manually.
#
# === Variables
#
# === Examples
#
# === Authors
#
# Andrew Kroenert akroenert@viator.com
#

class newrelic::repo (
  $manage_repo = newrelic::params::manage_repo,
){

  validate_bool($manage_repo)

  if $(manage_repo){

    case $::osfamily {
      'RedHat': {
        package { 'newrelic-repo-5-3.noarch':
          ensure   => present,
          source   => 'http://yum.newrelic.com/pub/newrelic/el5/x86_64/newrelic-repo-5-3.noarch.rpm',
          provider => rpm,
        }
      }
      'Debian': {
        apt::source { 'newrelic':
          location => 'http://apt.newrelic.com/debian/',
          repos    => 'non-free',
          key      => {
            id         => 'B60A3EC9BC013B9C23790EC8B31B29E5548C16BF',
            key_source => 'https://download.newrelic.com/548C16BF.gpg',
          },
          include  => {
            src => false,
          },
          release  => 'newrelic',
        }
      }
      'windows': {}
      default: {
        fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}")
      }
    }

  }

}
