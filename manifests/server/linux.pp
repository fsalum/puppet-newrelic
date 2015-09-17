# == Class: newrelic::server::linux
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
#   Specify the package update state. Defaults to 'present'. Possible value is 'latest'.
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
# Felipe Salum <fsalum@gmail.com>
#
# === Copyright
#
# Copyright 2012 Felipe Salum, unless otherwise noted.
#
class newrelic::server::linux (
  $newrelic_package_ensure           = 'present',
  $newrelic_service_enable           = true,
  $newrelic_service_ensure           = 'running',
  $newrelic_license_key              = undef,
  $newrelic_package_name             = $::newrelic::params::newrelic_package_name,
  $newrelic_service_name             = $::newrelic::params::newrelic_service_name,
  $newrelic_nrsysmond_loglevel       = undef,
  $newrelic_nrsysmond_logfile        = undef,
  $newrelic_nrsysmond_proxy          = undef,
  $newrelic_nrsysmond_ssl            = undef,
  $newrelic_nrsysmond_ssl_ca_bundle  = undef,
  $newrelic_nrsysmond_ssl_ca_path    = undef,
  $newrelic_nrsysmond_pidfile        = undef,
  $newrelic_nrsysmond_collector_host = undef,
  $newrelic_nrsysmond_timeout        = undef,
  $newrelic_nrsysmond_options        = {},
) inherits ::newrelic {

  if ! $newrelic_license_key {
    fail('You must specify a valid License Key.')
  }

  package { $newrelic_package_name:
    ensure  => $newrelic_package_ensure,
    notify  => Service[$newrelic_service_name],
    require => Class['newrelic::params'],
  }

  if ! $newrelic_nrsysmond_logfile {
    $logdir = '/var/log/newrelic'
  } else {
    $logdir = dirname($newrelic_nrsysmond_logfile)
  }

  file { $logdir:
    ensure  => directory,
    owner   => 'newrelic',
    group   => 'newrelic',
    require => Package[$newrelic_package_name],
    before  => Service[$newrelic_service_name],
  }

  file { '/etc/newrelic/nrsysmond.cfg':
    ensure  => present,
    path    => '/etc/newrelic/nrsysmond.cfg',
    content => template('newrelic/nrsysmond.cfg.erb'),
    require => Package[$newrelic_package_name],
    before  => Service[$newrelic_service_name],
    notify  => Service[$newrelic_service_name],
  }

  service { $newrelic_service_name:
    ensure     => $newrelic_service_ensure,
    enable     => $newrelic_service_enable,
    hasrestart => true,
    hasstatus  => true,
    require    => Exec[$newrelic_license_key],
  }

  exec { $newrelic_license_key:
    path    => '/bin:/usr/bin',
    command => "/usr/sbin/nrsysmond-config --set license_key=${newrelic_license_key}",
    user    => 'root',
    group   => 'root',
    unless  => "cat /etc/newrelic/nrsysmond.cfg | grep ${newrelic_license_key}",
    require => Package[$newrelic_package_name],
    notify  => Service[$newrelic_service_name],
  }

}
