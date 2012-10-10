# == Class: newrelic
#
# This class installs and configures NewRelic server monitoring and NewRelic PHP agent.
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
# [*newrelic_php*]
#   If set to true will install and configure Newrelic PHP agent. Defaults to false.
#
# [*newrelic_php_package_ensure*]
#   Specific the Newrelic PHP package update state. Defaults to 'present'. Possible value is 'latest'.
#
# [*newrelic_php_service_ensure*]
#   Specify the Newrelic PHP service running state. Defaults to 'running'. Possible value is 'stopped'.
#
# [*newrelic_php_conf_appname*]
#   Sets the name of the application as it will be seen in the New Relic UI
#
# [*newrelic_php_conf_enabled*]
#   By default the New Relic PHP agent is enabled for all directories. To disable set it to '0'.
#
# [*newrelic_php_conf_transaction*]
#   Turns on the "top 100 slowest calls" tracer. To enable set it to '1'.
#
# [*newrelic_php_conf_logfile*]
#   This identifies the file name for logging messages.
#
# [*newrelic_php_conf_loglevel*]
#   Sets the level of detail of messages sent to the log file. Possible values: error, warning, info, verbose, debug, verbosedebug.
#
# [*newrelic_php_conf_browser*]
#   This enables auto-insertion of the JavaScript fragments for browser monitoring. To disable set it to '0'.
#
# [*newrelic_php_conf_dberrors*]
#   It causes MySQL errors from all instrumented MySQL calls to be reported to New Relic. To enable set it to '1'.
#
# [*newrelic_php_conf_transactionrecordsql*]
#   When recording transaction traces internally, the full SQL for slow SQL calls is recorded. Possible values: off, raw, obfuscated.
#
# [*newrelic_php_conf_captureparams*]
#   This will enable the display of parameters passed to a PHP script via the URL. To enable set it to '1'.
#
#
# === Variables
#
# === Examples
#
#  class { newrelic:
#    newrelic_package_ensure                => 'latest',
#    newrelic_service_ensure                => 'running',
#    newrelic_license_key                   => '1234567890123456789012345678901234567890',
#    newrelic_php                           => true,
#    newrelic_php_package_ensure            => 'latest',
#    newrelic_php_service_ensure            => 'running',
#    newrelic_php_conf_appname              => 'Your PHP Application',
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
class newrelic (
  $newrelic_package_ensure                = 'present',
  $newrelic_service_ensure                = 'running',
  $newrelic_license_key                   = '',
  $newrelic_php                           = false,
  $newrelic_php_package_ensure            = 'present',
  $newrelic_php_service_ensure            = 'running',
  $newrelic_php_conf_appname              = 'Your PHP Application',
  $newrelic_php_conf_enabled              = '1',
  $newrelic_php_conf_logfile              = '/var/log/newrelic/php_agent.log',
  $newrelic_php_conf_loglevel             = 'info',
  $newrelic_php_conf_browser              = '1',
  $newrelic_php_conf_transaction          = '0',
  $newrelic_php_conf_dberrors             = '0',
  $newrelic_php_conf_transactionrecordsql = 'off',
  $newrelic_php_conf_captureparams        = '0',
) { 

  require newrelic::params

  $newrelic_package_name = $newrelic::params::newrelic_package_name
  $newrelic_service_name = $newrelic::params::newrelic_service_name
  $newrelic_php_package  = $newrelic::params::newrelic_php_package
  $newrelic_php_service  = $newrelic::params::newrelic_php_service
  $newrelic_php_conf_dir = $newrelic::params::newrelic_php_conf_dir

  package { $newrelic_package_name:
    ensure  => $newrelic_package_ensure,
    notify  => Service[$newrelic_service_name],
  }

  service { $newrelic_service_name:
    ensure     => $newrelic_service_ensure,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => Exec[$newrelic_license_key],
  }

  exec { $newrelic_license_key:
    path        => '/bin:/usr/bin',
    command     => "/usr/sbin/nrsysmond-config --set license_key=$newrelic_license_key",
    user        => 'root',
    group       => 'root',
    unless      => "cat /etc/newrelic/nrsysmond.cfg | grep $newrelic_license_key",
    require     => Package[$newrelic_package_name],
    notify      => Service[$newrelic_service_name],
  }

  if $newrelic_php {
    class { 'newrelic::php':
      newrelic_license_key                   => $newrelic_license_key,
      newrelic_php_package                   => $newrelic_php_package,
      newrelic_php_service                   => $newrelic_php_service,
      newrelic_php_conf_dir                  => $newrelic_php_conf_dir,
      newrelic_php_conf_appname              => $newrelic_php_conf_appname,
      newrelic_php_conf_enabled              => $newrelic_php_conf_enabled,
      newrelic_php_conf_logfile              => $newrelic_php_conf_logfile,
      newrelic_php_conf_loglevel             => $newrelic_php_conf_loglevel,
      newrelic_php_conf_browser              => $newrelic_php_conf_browser,
      newrelic_php_conf_transaction          => $newrelic_php_conf_transaction,
      newrelic_php_conf_dberrors             => $newrelic_php_conf_dberrors,
      newrelic_php_conf_transactionrecordsql => $newrelic_php_conf_transactionrecordsql,
      newrelic_php_conf_captureparams        => $newrelic_php_conf_captureparams,
    }
  }

}
