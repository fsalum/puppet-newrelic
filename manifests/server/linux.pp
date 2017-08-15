# == Class: newrelic::server::linux
#
# This class installs and configures NewRelic server monitoring.
#
# === Parameters
#
# [*service_enable*]
#   Specify the service startup state. Defaults to true. Possible value is false.
#
# [*service_ensure*]
#   Specify the service running state. Defaults to 'running'. Possible value is 'stopped'.
#
# [*package_ensure*]
#   Specify the package update state. Defaults to 'present'. Possible value is 'latest'.
#
# [*license_key*]
#   Specify your Newrelic License Key.
#
# === Variables
#
# === Examples
#
#  class {'newrelic::server::linux':
#      license_key    => 'your license key here',
#      package_ensure => 'latest',
#      service_ensure => 'running',
#  }
#
# === Authors
#
# Felipe Salum <fsalum@gmail.com>
# Craig Watson <craig.watson@claranet.uk>
#
# === Copyright
#
# Copyright 2012 Felipe Salum
# Copyright 2017 Claranet
#
class newrelic::server::linux (
  String                $license_key,
  Boolean               $manage_repo    = $::newrelic::params::manage_repo,
  String                $package_name   = $::newrelic::params::server_package_name,
  String                $service_name   = $::newrelic::params::server_service_name,
  String                $package_ensure = 'present',
  Boolean               $service_enable = true,
  String                $service_ensure = 'running',
  String                $logfile        = '/var/log/newrelic/nrsysmond.log',
  Variant[Undef,String] $log_level      = undef,
  Variant[Undef,String] $proxy          = undef,
  Variant[Undef,String] $ssl            = undef,
  Variant[Undef,String] $ssl_ca_bundle  = undef,
  Variant[Undef,String] $ssl_ca_path    = undef,
  Variant[Undef,String] $pidfile        = undef,
  Variant[Undef,String] $collector_host = undef,
  Variant[Undef,String] $labels         = undef,
  Variant[Undef,String] $timeout        = undef,
  Variant[Undef,String] $hostname       = undef,
) inherits newrelic::params {

  $logdir = dirname($logfile)

  if $manage_repo == true {
    include ::newrelic::server::linux::repo
    Package[$package_name] {
      require => $::newrelic::server::linux::repo::require,
    }
  }

  package { $package_name:
    ensure => $package_ensure,
  }

  exec { 'install_newrelic_license_key':
    command => "/usr/sbin/nrsysmond-config --set license_key=${license_key}",
    user    => 'root',
    unless  => "/bin/grep -q ${license_key} /etc/newrelic/nrsysmond.cfg",
    notify  => Service[$service_name],
    require => Package[$package_name]
  }

  file { $logdir:
    ensure  => directory,
    owner   => 'newrelic',
    group   => 'newrelic',
    require => Exec['install_newrelic_license_key'],
  }

  file { '/etc/newrelic/nrsysmond.cfg':
    ensure  => present,
    path    => '/etc/newrelic/nrsysmond.cfg',
    content => template('newrelic/nrsysmond.cfg.erb'),
    require => File[$logdir],
    notify  => Service[$service_name],
  }

  service { $service_name:
    ensure     => $service_ensure,
    enable     => $service_enable,
    hasrestart => true,
    hasstatus  => true,
    require    => File['/etc/newrelic/nrsysmond.cfg'],
  }

}
