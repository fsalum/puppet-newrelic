# == Class: newrelic::agent::php
#
# This class install the New Relic PHP Agent
#
# === Parameters:
#
# [*license_key*]
#   NewRelic API license key (String)
#
# [*manage_repo*]
#   Whether to install the NewRelic OS repositories
#   Default: OS dependant - see params.pp (Boolean)
#
# [*conf_dir*]
#   Main Configuration directory used for PHP.
#   Default: OS dependant - see params.pp (String)
#
# [*purge_files*]
#   Any files which should be purged following the installation. This is only
#   necessary as the NewRelic installer adds files to every possible location,
#   resulting in duplicate configuration.
#   Default: OS dependant - see params.pp (Array)
#
# [*package_name*]
#   Name of the package to install
#   Default: OS dependant - see params.pp (String)
#
# [*service_name*]
#   Name of the service running the PHP agent
#   Default: OS dependant - see params.pp (String)
#
# [*package_ensure*]
#   Specific the Newrelic PHP package update state.
#   Default: 'present' (String)
#
# [*startup_mode*]
#   Sets the startup mode to either 'agent' or 'external'.
#   For more detail, see: https://docs.newrelic.com/docs/agents/php-agent/advanced-installation/starting-php-daemon-advanced
#   Default: 'agent' (String)
#
# [*ini_settings*]
#   Key/Value hash of settings to add to newrelic.ini files within $conf_dir,
#   see below example. NOTE that all settings are added to the [newrelic]
#   section with the "newrelic." prefix. For more info on possible parameters,
#   see: https://docs.newrelic.com/docs/php/php-agent-phpini-settings
#   Default: {} (Hash)
#
# === Examples
#
# To set a custom application name and disable the daemon service
#
# class { '::newrelic::agent::php':
#   license_key   => 'your license key here',
#   daemon_enable => false,
#   ini_settings  => {
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
  String                   $license_key,
  Boolean                  $manage_repo      = $::newrelic::params::manage_repo,
  String                   $conf_dir         = $::newrelic::params::php_conf_dir,
  Array                    $purge_files      = $::newrelic::params::php_purge_files,
  String                   $package_name     = $::newrelic::params::php_package_name,
  String                   $service_name     = $::newrelic::params::php_service_name,
  String                   $package_ensure   = 'present',
  Enum['agent','external'] $startup_mode     = 'agent',
  String                   $service_ensure   = 'running',
  Boolean                  $service_enable   = true,
  Hash                     $ini_settings     = {},

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

  if $startup_mode == 'agent' {
    $daemon_config_ensure = absent
  } else {
    $daemon_config_ensure = file
  }

  # == Installation

  if $manage_repo == true {
    include ::newrelic::repo::legacy
    Package[$package_name] {
      require => $::newrelic::repo::legacy::require
    }
  }

  package { $package_name:
    ensure  => $package_ensure,
  }

  # == Configuration

  file { '/etc/newrelic/newrelic.cfg':
    ensure  => $daemon_config_ensure,
    path    => '/etc/newrelic/newrelic.cfg',
    content => template('newrelic/daemon/newrelic.cfg.erb'),
    require => Package[$package_name],
    before  => Service[$service_name],
    notify  => Service[$service_name],
  }

  exec { 'newrelic install':
    command => "/usr/bin/newrelic-install purge; NR_INSTALL_SILENT=yes, NR_INSTALL_KEY=${license_key} /usr/bin/newrelic-install install",
    user    => 'root',
    unless  => "/bin/grep -q ${license_key} ${conf_dir}/newrelic.ini",
    require => Package[$package_name],
  }

  $ini_defaults = {
    ensure  => present,
    section => 'newrelic',
    path    => "${conf_dir}/newrelic.ini",
    require => Exec['newrelic install'],
  }

  ini_setting { 'newrelic.license':
    setting => 'newrelic.license',
    value   => $license_key,
    *       => $ini_defaults,
  }

  $ini_settings.each |String $k, String $v| {
    ini_setting { "newrelic.${k}":
      setting => "newrelic.${k}",
      value   => $v,
      *       => $ini_defaults,
    }
  }

  file { $purge_files:
    ensure  => absent,
    require => Exec['newrelic install']
  }

  service { $service_name:
    ensure     => $service_ensure,
    enable     => $service_enable,
    hasrestart => true,
    hasstatus  => true,
  }

}
