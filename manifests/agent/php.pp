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
# For detailed explanation about the parameters below see: https://docs.newrelic.com/docs/php/php-agent-phpini-settings
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
  String  $package_ensure                           = 'present',
  String  $service_ensure                           = 'running',
  Boolean $service_enable                           = false,
  String  $conf_dir                                 = $::newrelic::params::php_conf_dir,
  String  $package_name                             = $newrelic::params::php_package_name,
  String  $service_name                             = $newrelic::params::php_service_name,
  String  $daemon_config_ensure                     = 'present',




  $newrelic_ini_appname                                  = undef,
  $newrelic_ini_browser_monitoring_auto_instrument       = undef,
  $newrelic_ini_enabled                                  = undef,
  $newrelic_ini_error_collector_enabled                  = undef,
  $newrelic_ini_error_collector_prioritize_api_errors    = undef,
  $newrelic_ini_error_collector_record_database_errors   = undef,
  $newrelic_ini_framework                                = undef,
  $newrelic_ini_high_security                            = undef,
  $newrelic_ini_logfile                                  = undef,
  $newrelic_ini_loglevel                                 = undef,
  $newrelic_ini_transaction_tracer_custom                = undef,
  $newrelic_ini_transaction_tracer_detail                = undef,
  $newrelic_ini_transaction_tracer_enabled               = undef,
  $newrelic_ini_transaction_tracer_explain_enabled       = undef,
  $newrelic_ini_transaction_tracer_explain_threshold     = undef,
  $newrelic_ini_transaction_tracer_record_sql            = undef,
  $newrelic_ini_transaction_tracer_slow_sql              = undef,
  $newrelic_ini_transaction_tracer_stack_trace_threshold = undef,
  $newrelic_ini_transaction_tracer_threshold             = undef,
  $newrelic_ini_capture_params                           = undef,
  $newrelic_ini_ignored_params                           = undef,
  $newrelic_ini_webtransaction_name_files                = undef,

  $newrelic_daemon_dont_launch                           = undef,
  $newrelic_daemon_pidfile                               = undef,
  $newrelic_daemon_location                              = undef,
  $newrelic_daemon_logfile                               = undef,
  $newrelic_daemon_loglevel                              = undef,
  $newrelic_daemon_port                                  = undef,
  $newrelic_daemon_ssl                                   = undef,
  $newrelic_daemon_ssl_ca_bundle                         = undef,
  $newrelic_daemon_ssl_ca_path                           = undef,
  $newrelic_daemon_proxy                                 = undef,
  $newrelic_daemon_collector_host                        = undef,
  $newrelic_daemon_auditlog                              = undef,
) inherits newrelic::params {

  if $manage_repo == true {
    include ::newrelic::legacy_repo
    Package[$package_name] {
      require => $::newrelic::legacy_repo::require
    }
  }

  package { $package_name:
    ensure  => $package_ensure,
  }

  $conf_dir.each |String $dir| {
    exec { "newrelic install ${dir}":
      command  => "/usr/bin/newrelic-install purge; NR_INSTALL_SILENT=yes, NR_INSTALL_KEY=${license_key} /usr/bin/newrelic-install install",
      user     => 'root',
      unless   => "grep -q ${license_key} ${dir}/newrelic.ini",
      require  => Package[$package_name],
    }

    file { "${dir}/newrelic.ini":
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('newrelic/newrelic.ini.erb'),
      require => Exec["newrelic install ${dir}"],
    }
  }

  file { '/etc/newrelic/newrelic.cfg':
    ensure  => $daemon_config_ensure,
    path    => '/etc/newrelic/newrelic.cfg',
    content => template('newrelic/newrelic.cfg.erb'),
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
