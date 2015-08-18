# Class: newrelic::php
#
# This class install the New Relic PHP Agent
#
# Parameters:
#
# [*newrelic_php_package_ensure*]
#   Specific the Newrelic PHP package update state. Defaults to 'present'. Possible value is 'latest'.
#
# [*newrelic_php_service_ensure*]
#   Specify the Newrelic PHP service running state. Defaults to 'running'. Possible value is 'stopped'.
#
# [*newrelic_daemon_cfgfile_ensure*]
#   Specify the Newrelic daemon cfg file state. Change to absent for agent startup mode. Defaults to 'present'. Possible value is 'absent'.
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
#  newrelic::php {
#    'appXYZ':
#      newrelic_license_key        => 'your license key here',
#      newrelic_php_package_ensure => 'latest',
#      newrelic_php_service_ensure => 'running',
#      newrelic_ini_appname        => 'Your PHP Application',
#    }
#
# If no parameters are set it will use the newrelic.ini defaults
#
# For detailed explanation about the parameters below see: https://docs.newrelic.com/docs/php/php-agent-phpini-settings
#
define newrelic::php (
  $newrelic_php_package_ensure                           = 'present',
  $newrelic_php_service_ensure                           = 'running',
  $newrelic_php_conf_dir                                 = $newrelic::params::newrelic_php_conf_dir,
  $newrelic_license_key                                  = undef,
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
  $newrelic_daemon_cfgfile_ensure                        = 'present',
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
  $newrelic_hostname                                     = undef,
  ### Deprecated below
  $newrelic_php_conf_appname              = undef,
  $newrelic_php_conf_enabled              = undef,
  $newrelic_php_conf_transaction          = undef,
  $newrelic_php_conf_logfile              = undef,
  $newrelic_php_conf_loglevel             = undef,
  $newrelic_php_conf_browser              = undef,
  $newrelic_php_conf_dberrors             = undef,
  $newrelic_php_conf_transactionrecordsql = undef,
  $newrelic_php_conf_captureparams        = undef,
  $newrelic_php_conf_ignoredparams        = undef,
) {

  include newrelic

  $newrelic_php_package  = $newrelic::params::newrelic_php_package
  $newrelic_php_service  = $newrelic::params::newrelic_php_service

  warning('newrelic::php is deprecated. Please switch to the newrelic::agent::php class.')

  if ! $newrelic_license_key {
    fail('You must specify a valid License Key.')
  }

  package { $newrelic_php_package:
    ensure  => $newrelic_php_package_ensure,
    require => Class['newrelic::params'],
  }

  service { $newrelic_php_service:
    ensure     => $newrelic_php_service_ensure,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
  }

  ::newrelic::php::newrelic_ini { $newrelic_php_conf_dir:
    newrelic_license_key => $newrelic_license_key,
    before               => [ File['/etc/newrelic/newrelic.cfg'], Service[$newrelic_php_service] ],
    require              => Package[$newrelic_php_package],
    notify               => Service[$newrelic_php_service],
  }

  file { '/etc/newrelic/newrelic.cfg':
    ensure  => $newrelic_daemon_cfgfile_ensure,
    path    => '/etc/newrelic/newrelic.cfg',
    content => template('newrelic/newrelic.cfg.erb'),
    before  => Service[$newrelic_php_service],
    notify  => Service[$newrelic_php_service],
  }

  # Fail on renamed/deprecated variables if they are still used
  if $newrelic_php_conf_appname {
    fail('Variable $newrelic_php_conf_appname is deprecated, use $newrelic_ini_appname instead.')
  }
  if $newrelic_php_conf_browser {
    fail('Variable $newrelic_php_conf_browser is deprecated, use $newrelic_ini_browser_monitoring_auto_instrument instead.')
  }
  if $newrelic_php_conf_captureparams {
    fail('Variable $newrelic_php_conf_captureparams is deprecated, use $newrelic_ini_capture_params instead.')
  }
  if $newrelic_php_conf_dberrors {
    fail('Variable $newrelic_php_conf_dberrors is deprecated, use $newrelic_ini_error_collector_record_database_errors instead.')
  }
  if $newrelic_php_conf_enabled {
    fail('Variable $newrelic_php_conf_enabled is deprecated, use $newrelic_ini_enabled instead.')
  }
  if $newrelic_php_conf_ignoredparams {
    fail('Variable $newrelic_php_conf_ignoredparams is deprecated, use $newrelic_ini_ignored_params instead.')
  }
  if $newrelic_php_conf_logfile {
    fail('Variable $newrelic_php_conf_logfile is deprecated, use $newrelic_ini_logfile instead.')
  }
  if $newrelic_php_conf_loglevel {
    fail('Variable $newrelic_php_conf_loglevel is deprecated, use $newrelic_ini_loglevel instead.')
  }
  if $newrelic_php_conf_transactionrecordsql {
    fail('Variable $newrelic_php_conf_transactionrecordsql is deprecated, use $newrelic_ini_transaction_tracer_record_sql instead.')
  }
  if $newrelic_php_conf_transaction {
    fail('Variable $newrelic_php_conf_transaction is deprecated, use $newrelic_ini_transaction_tracer_detail instead.')
  }

}
