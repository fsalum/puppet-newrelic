# == Class: newrelic::server::windows
#
# This class installs and configures NewRelic server monitoring.
#
# === Parameters
#
# [*newrelic_service_enable*]
#   Specify the service startup state. Defaults to true. Possible value is false.
#
# [*newrelic_service_ensure*]
#   Specify the service running state. Defaults to 'running'. Possible value is 'stopped'.
#
# [*newrelic_package_ensure*]
#   Specify the package update state. Defaults to 'present'. Possible values are specific versions of the server agent.
#
# [*newrelic_license_key*]
#   Specify your Newrelic License Key.
#
# === Variables
#
# === Examples
#
#  class {'newrelic::server::linux':
#      newrelic_license_key    => 'your license key here',
#      newrelic_package_ensure => 'latest',
#      newrelic_service_ensure => 'running',
#  }
#
# === Authors
#
# Ben Priestman <ben.priestman@immediate.co.uk>
#
# === Copyright
#
# Copyright 20125 Ben Priestman, unless otherwise noted.
#
class newrelic::server::windows (
  $newrelic_package_ensure           = 'present',
  $newrelic_service_enable           = true,
  $newrelic_service_ensure           = 'running',
  $newrelic_license_key              = undef,
  $newrelic_package_name             = $::newrelic::params::newrelic_package_name,
  $newrelic_service_name             = $::newrelic::params::newrelic_service_name,
  $temp_dir                          = $::newrelic::params::temp_dir ,
  $server_monitor_source             = $::newrelic::params::server_monitor_source,
) inherits ::newrelic {

  if ! $newrelic_license_key {
    fail('You must specify a valid License Key.')
  }

  case $newrelic_package_ensure {
    'absent':   {
      $package_source = false
    }
    'present','installed':  {
      $package_source   = "${server_monitor_source}/${::architecture}"
      $destination_file = "NewRelicServerMonitor_${::architecture}.msi"
    }
    'latest':   {
      fail("'latest' is not a valid value for this package, as we have no way of determining which version is the latest one. You can specify a specific version, though.")
    }
    default:    {
      $package_source   = "${server_monitor_source}/NewRelicServerMonitor_${::architecture}_${newrelic_package_ensure}.msi"
      $destination_file = "NewRelicServerMonitor_${::architecture}_${newrelic_package_ensure}.msi"
    }
  }

  if $package_source {
    download_file {$destination_file:
      url                   => $package_source,
      destination_directory => $temp_dir,
      destination_file      => $destination_file,
      before                => Package[$newrelic_package_name],
    }
  }

  package { $newrelic_package_name:
    ensure          => $newrelic_package_ensure,
    notify          => Service[$newrelic_service_name],
    source          => "${temp_dir}\\${destination_file}",
    install_options => [
      '/L*v',
      "${temp_dir}\\NewRelicServerMonitor_install.log",
      {
        'NR_LICENSE_KEY' => $newrelic_license_key
      }
    ],
    require         => Class['newrelic::params'],
  }

  service { $newrelic_service_name:
    ensure     => $newrelic_service_ensure,
    enable     => $newrelic_service_enable,
    hasrestart => true,
    hasstatus  => true,
  }


}
