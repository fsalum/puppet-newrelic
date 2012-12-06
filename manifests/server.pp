# == Class: newrelic::server
#
# This class installs and configures NewRelic server monitoring.
#
# === Parameters
#
# [*newrelic_service_ensure*]
#   Specify the service running state. Defaults to 'running'. Possible value is 'stopped'.
#
# [*newrelic_package_ensure*]
#   Specify the package update state. Defaults to 'present'. Possible value is 'latest'.
#
# [*newrelic_license_key*]
#   Specify your Newrelic License Key.
#
# === Variables
#
# === Examples
#
#  newrelic::server {
#    'serverXYZ':
#      newrelic_license_key    => 'your license key here',
#      newrelic_package_ensure => 'latest',
#      newrelic_service_ensure => 'running',
#  }
#
# === Authors
#
# Felipe Salum <fsalum@gmail.com>
#
# === Copyright
#
# Copyright 2012 Felipe Salum, unless otherwise noted.
#
define newrelic::server (
  $newrelic_license_key    = '',
  $newrelic_package_ensure = 'present',
  $newrelic_service_ensure = 'running',
) {

  include newrelic

  $newrelic_package_name = $newrelic::params::newrelic_package_name
  $newrelic_service_name = $newrelic::params::newrelic_service_name

  package { $newrelic_package_name:
    ensure  => $newrelic_package_ensure,
    notify  => Service[$newrelic_service_name],
    require => Apt::Source['newrelic'],
  }

  service { $newrelic_service_name:
    ensure     => $newrelic_service_ensure,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => [ Exec[$newrelic_license_key], Package[$newrelic_package_name] ],
  }

  exec { $newrelic_license_key:
    path        => '/bin:/usr/bin',
    command     => "/usr/sbin/nrsysmond-config --set license_key=${newrelic_license_key}",
    user        => 'root',
    group       => 'root',
    unless      => "cat /etc/newrelic/nrsysmond.cfg | grep ${newrelic_license_key}",
    require     => Package[$newrelic_package_name],
    notify      => Service[$newrelic_service_name],
  }

}
