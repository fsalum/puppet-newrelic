# Class: newrelic::infra
# =============================
#
# Installs and starts the New Relic Infrastrucure Agent, and replaces the
# deprecated server class.
#
# === Parameters
#
# [*license_key*]
#   NewRelic API license key (String)
#
# [*manage_repo*]
#   Whether to install the NewRelic OS repositories
#   Default: Varies depending on OS (Boolean)
#
class newrelic::infra (
  String $license_key,
  Boolean $manage_repo = $::newrelic::params::manage_repo,
) inherits newrelic::params {

  file { '/etc/newrelic-infra.yml':
    ensure  => file,
    content => "license_key: $license_key\n",
    notify  => Service['newrelic-infra'],
  }

  if $::newrelic::infra::manage_repo == true {

    include ::newrelic::infra::repo

    case $facts['os']['family'] {
      'RedHat': {
        File['/etc/newrelic-infra.yml'] {
          require => Yumrepo['newrelic-infra'],
        }
      }

      'Debian': {
        File['/etc/newrelic-infra.yml'] {
          require => Apt::Source['newrelic-infra'],
        }
      }

      default: {
        fail("Repo not supported for $facts[os][family]")
      }
    }
  }

  package { 'newrelic-infra':
    ensure  => present,
    require => File['/etc/newrelic-infra.yml'],
  }

  service { 'newrelic-infra':
    ensure  => running,
    require => Package['newrelic-infra']
  }

}
