# == Class: newrelic::params
#
# This class handles parameters for the newrelic module
#
# == Actions:
#
# None
#
# === Authors:
#
# Felipe Salum <fsalum@gmail.com>
# Craig Watson <craig.watson@claranet.uk>
#
# === Copyright:
#
# Copyright 2012 Felipe Salum
# Copyright 2017 Claranet
#
class newrelic::params {

  case $facts['os']['family'] {
    'RedHat': {
      $manage_repo         = true
      $server_package_name = 'newrelic-sysmond'
      $server_service_name = 'newrelic-sysmond'
      $php_package_name    = 'newrelic-php5'
      $php_service_name    = 'newrelic-daemon'
      $php_conf_dir        = ['/etc/php.d']
    }

    'Debian': {
      $manage_repo         = true
      $server_package_name = 'newrelic-sysmond'
      $server_service_name = 'newrelic-sysmond'
      $php_package_name    = 'newrelic-php5'
      $php_service_name    = 'newrelic-daemon'
      $php_conf_dir        = ['/etc/php5/mods-available']
    }

    'Windows': {
      $manage_repo             = false
      $bitness                 = regsubst($facts['architecture'],'^x([\d]{2})','\1')
      $server_package_name     = 'New Relic Server Monitor'
      $server_service_name     = 'nrsvrmon'
      $temp_dir                = 'C:/Windows/temp'
      $server_monitor_source   = 'http://download.newrelic.com/windows_server_monitor/release/'
      $dotnet_conf_dir         = 'C:\\ProgramData\\New Relic\\.NET Agent'
      $dotnet_package          = "New Relic .NET Agent (${bitness}-bit)"
      $dotnet_source           = 'http://download.newrelic.com/dot_net_agent/release/'
      $dotnet_application_name = 'My Application'
    }

    default: {
      fail("Unsupported osfamily: ${facts[osfamily]} operatingsystem: ${facts[operatingsystem]}")
    }
  }

}
