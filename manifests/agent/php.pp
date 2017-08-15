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
  Array   $conf_dir                                 = $::newrelic::params::php_conf_dir,
  String  $service_name                             = $::newrelic::params::php_service_name,
  String  $package_name                             = $::newrelic::params::php_package_name,
  String  $package_ensure                           = 'present',
  String  $service_ensure                           = 'running',
  Boolean $service_enable                           = false,
  String  $daemon_config_ensure                     = 'present',

  $ini_appname                                  = undef,
  $ini_browser_monitoring_auto_instrument       = undef,
  $ini_enabled                                  = undef,
  $ini_error_collector_enabled                  = undef,
  $ini_error_collector_prioritize_api_errors    = undef,
  $ini_error_collector_record_database_errors   = undef,
  $ini_framework                                = undef,
  $ini_high_security                            = undef,
  $ini_logfile                                  = undef,
  $ini_loglevel                                 = undef,
  $ini_transaction_tracer_custom                = undef,
  $ini_transaction_tracer_detail                = undef,
  $ini_transaction_tracer_enabled               = undef,
  $ini_transaction_tracer_explain_enabled       = undef,
  $ini_transaction_tracer_explain_threshold     = undef,
  $ini_transaction_tracer_record_sql            = undef,
  $ini_transaction_tracer_slow_sql              = undef,
  $ini_transaction_tracer_stack_trace_threshold = undef,
  $ini_transaction_tracer_threshold             = undef,
  $ini_capture_params                           = undef,
  $ini_ignored_params                           = undef,
  $ini_webtransaction_name_files                = undef,

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
      unless   => "/bin/grep -q ${license_key} ${dir}/newrelic.ini",
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
