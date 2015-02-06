# Class: newrelic::agent::php
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
#  class {'newrelic::agent::php':
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
class newrelic::agent::php (
  $newrelic_php_package_ensure                           = 'present',
  $newrelic_php_service_ensure                           = 'running',
  $newrelic_php_service_enable                           = true,
  $newrelic_php_conf_dir                                 = $::newrelic::params::newrelic_php_conf_dir,
  $newrelic_php_exec_path                                = $::path,
  $newrelic_php_package                                  = $::newrelic::params::newrelic_php_package,
  $newrelic_php_service                                  = $::newrelic::params::newrelic_php_service,
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
  $newrelic_ini_webtransaction_name_files                = undef,
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
) inherits ::newrelic::params {

  if ! $newrelic_license_key {
    fail('You must specify a valid License Key.')
  }

  package { $newrelic_php_package:
    ensure  => $newrelic_php_package_ensure,
    require => Class['::newrelic::params'],
  }

  service { $newrelic_php_service:
    ensure     => $newrelic_php_service_ensure,
    enable     => $newrelic_php_service_enable,
    hasrestart => true,
    hasstatus  => true,
  }

  ::newrelic::php::newrelic_ini { $newrelic_php_conf_dir:
    exec_path            => $newrelic_php_exec_path,
    newrelic_license_key => $newrelic_license_key,
    content              => template("${module_name}/newrelic.ini.erb"),
    before               => [ File['/etc/newrelic/newrelic.cfg'], Service[$newrelic_php_service] ],
    require              => Package[$newrelic_php_package],
    notify               => Service[$newrelic_php_service],
  }

  file { '/etc/newrelic/newrelic.cfg':
    ensure  => $newrelic_daemon_cfgfile_ensure,
    content => template('newrelic/newrelic.cfg.erb'),
    before  => Service[$newrelic_php_service],
    notify  => Service[$newrelic_php_service],
  }

}
