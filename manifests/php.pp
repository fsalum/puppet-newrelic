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
# [*newrelic_php_conf_appname*]
#   Sets the name of the application as it will be seen in the New Relic UI
#
# [*newrelic_php_conf_enabled*]
#   By default the New Relic PHP agent is enabled for all directories. To disable set it to '0'.
#
# [*newrelic_php_conf_transaction*]
#   This traces all calls, not just those calls internally instrumented by New Relic. To disable set it to '0'.
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
#      newrelic_php_conf_appname   => 'Your PHP Application',
#    }
#
define newrelic::php (
  $newrelic_license_key                   = '',
  $newrelic_php_package_ensure            = 'present',
  $newrelic_php_service_ensure            = 'running',
  $newrelic_php_conf_appname              = 'Your PHP Application',
  $newrelic_php_conf_enabled              = '1',
  $newrelic_php_conf_transaction          = '1',
  $newrelic_php_conf_logfile              = '/var/log/newrelic/php_agent.log',
  $newrelic_php_conf_loglevel             = 'info',
  $newrelic_php_conf_browser              = '1',
  $newrelic_php_conf_dberrors             = '0',
  $newrelic_php_conf_transactionrecordsql = 'off',
  $newrelic_php_conf_captureparams        = '0',
  $newrelic_daemon_pidfile                = '/var/run/newrelic-daemon.pid',
  $newrelic_daemon_logfile                = '/var/log/newrelic/newrelic-daemon.log',
  $newrelic_daemon_loglevel               = 'info',
  $newrelic_daemon_port                   = '33142',
  $newrelic_daemon_ssl                    = 'false',
  $newrelic_daemon_proxy                  = '',
  $newrelic_daemon_ssl_ca_bundle          = '',
  $newrelic_daemon_ssl_ca_path            = '',
  $newrelic_daemon_max_threads            = '8',
  $newrelic_daemon_collector_host         = 'collector.newrelic.com',
) {

  include newrelic

  $newrelic_php_package  = $newrelic::params::newrelic_php_package
  $newrelic_php_service  = $newrelic::params::newrelic_php_service
  $newrelic_php_conf_dir = $newrelic::params::newrelic_php_conf_dir

  package { $newrelic_php_package:
    ensure  => $newrelic_php_package_ensure,
    require => Class['newrelic::params'],
  }

  service { $newrelic_php_service:
    ensure     => $newrelic_php_service_ensure,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => Exec['/usr/bin/newrelic-install'],
  }

  exec { '/usr/bin/newrelic-install':
    path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    command     => "/usr/bin/newrelic-install purge ; NR_INSTALL_SILENT=yes, NR_INSTALL_KEY=${newrelic_license_key} /usr/bin/newrelic-install install",
    provider    => 'shell',
    user        => 'root',
    group       => 'root',
    unless      => "cat ${newrelic_php_conf_dir}/newrelic.ini | grep ${newrelic_license_key}",
    require     => Package[$newrelic_php_package],
  }

  file { 'newrelic.ini':
    path    => "${newrelic_php_conf_dir}/newrelic.ini",
    content => template('newrelic/newrelic.ini.erb'),
    require => Exec['/usr/bin/newrelic-install'],
  }

  file { '/etc/newrelic/newrelic.cfg':
    path    => '/etc/newrelic/newrelic.cfg',
    content => template('newrelic/newrelic.cfg.erb'),
    require => Exec['/usr/bin/newrelic-install'],
    before  => Service[$newrelic_php_service],
  }

}
