# == Class: newrelic::agent::php
#
# This class install the New Relic PHP Agent
#
# === Parameters:
#
# [*package_ensure*]
#   Specific the Newrelic PHP package update state.
#   Default: 'present' (String)
#
# [*service_ensure*]
#   Specify the Newrelic PHP service running state.
#   Default: 'running' (String)
#
# [*service_enable*]
#   Specify the Newrelic PHP service startup state.
#   Default: true (Boolean)
#
# [*daemon_config_ensure*]
#   Specify the Newrelic daemon config file state. Change to absent for agent startup mode.
#   Default: 'present' (String)
#
# [*conf_dir*]
#   List of configuration directories used for PHP. Pass multiple directories for setups like PHP-FPM or mod_php.
#   Default: OS dependant (see params.pp)
#
# [*ini_settings*]
#   Key/Value hash of settings to add to newrelic.ini files within $conf_dir - see below example.
#   NOTE that all settings are added to the [newrelic] section with the "newrelic." prefix.
#   For more info on possible parameters, see: https://docs.newrelic.com/docs/php/php-agent-phpini-settings
#   Default: {} (Hash)
#
# === Examples
#
# class { '::newrelic::agent::php':
#   license_key          => 'your license key here',
#   daemon_config_ensure => 'absent',
#   ini_settings         => {
#     'appname' => 'My PHP Application',
#   },
# }
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
class newrelic::agent::php (
  String  $license_key,
  Boolean $manage_repo                              = $::newrelic::params::manage_repo,
  Array   $conf_dir                                 = $::newrelic::params::php_conf_dir,
  String  $service_name                             = $::newrelic::params::php_service_name,
  String  $package_name                             = $::newrelic::params::php_package_name,
  String  $package_ensure                           = 'present',
  String  $service_ensure                           = 'running',
  Boolean $service_enable                           = false,
  String  $daemon_config_ensure                     = 'present',
  Hash    $ini_settings                             = {},

  $daemon_dont_launch                           = undef,
  $daemon_pidfile                               = undef,
  $daemon_location                              = undef,
  $daemon_logfile                               = undef,
  $daemon_loglevel                              = undef,
  $daemon_port                                  = undef,
  $daemon_ssl                                   = undef,
  $daemon_ssl_ca_bundle                         = undef,
  $daemon_ssl_ca_path                           = undef,
  $daemon_proxy                                 = undef,
  $daemon_collector_host                        = undef,
  $daemon_auditlog                              = undef,
) inherits newrelic::params {

  if $manage_repo == true {
    include ::newrelic::repo::legacy
    Package[$package_name] {
      require => $::newrelic::repo::legacy::require
    }
  }

  package { $package_name:
    ensure  => $package_ensure,
  }

  $conf_dir.each |String $dir| {
    exec { "newrelic install ${dir}":
      command  => "/usr/bin/newrelic-install purge; NR_INSTALL_SILENT=yes, NR_INSTALL_KEY=${license_key} /usr/bin/newrelic-install install",
      user     => 'root',
      unless   => "/bin/grep -q ${license_key} ${dir}/newrelic.ini",
      require  => Package[$package_name],
    }

    $ini_defaults = {
      ensure  => present,
      section => 'newrelic',
      path    => "${dir}/newrelic.ini",
      require => Exec["newrelic install ${dir}"],
    }

    ini_setting { 'newrelic.license':
      setting => 'newrelic.license',
      value   => $license_key,
      *       => $ini_defaults,
    }

    $ini_settings.each |String $k, String $v| {
      ini_setting { "newrelic.$k":
        setting => "newrelic.$k",
        value   => $v,
        *       => $ini_defaults,
      }
    }
  }

  # == Daemon

  file { '/etc/newrelic/newrelic.cfg':
    ensure  => $daemon_config_ensure,
    path    => '/etc/newrelic/newrelic.cfg',
    content => template('newrelic/daemon/newrelic.cfg.erb'),
    require => Package[$package_name],
    before  => Service[$service_name],
    notify  => Service[$service_name],
  }

  service { $service_name:
    ensure     => $service_ensure,
    enable     => $service_enable,
    hasrestart => true,
    hasstatus  => true,
  }
}
