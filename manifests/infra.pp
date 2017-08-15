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

  if $::newrelic::infra::manage_repo == true {
    contain ::newrelic::infra::repo
    File['/etc/newrelic-infra.yml'] {
      require => $::newrelic::infra::repo::require,
    }
  }

  file { '/etc/newrelic-infra.yml':
    ensure  => file,
    content => "license_key: $license_key\n",
    notify  => Service['newrelic-infra'],
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
