# == Class: newrelic::infrastructure
#
# [*newrelic_license_key*]
#   License key from new relic. Required.
#
class newrelic::infrastructure (
  $newrelic_license_key = undef,
  $newrelic_infra_conf_file = $newrelic::params::infra_conf_file
) inherits newrelic::params {
  include ::newrelic

  if ! $newrelic_license_key {
    fail('You must specify a valid License Key.')
  }

  case $::kernel {
    'Linux': {
      contain ::newrelic::infrastructure::linux
    }
    'Windows': {
      contain ::newrelic::infrastructure::windows
    }
    default: {
      warning("Unsupported Kernel ${::kernel}")
    }
  }

  file { $newrelic_infra_conf_file:
    ensure  => file,
    require => Package['newrelic-infra'],
  }->

  file_line {'Add License key for config YML':
    ensure  => present,
    path    => $newrelic_infra_conf_file,
    line    => "license_key: ${newrelic_license_key}",
    match   => '^license_key:',
    require => Package['newrelic-infra'],
  }->

  service{'newrelic-infra':
    ensure  => running,
    require => Package['newrelic-infra'],
  }
}
