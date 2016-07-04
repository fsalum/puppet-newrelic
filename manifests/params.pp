# Class: newrelic::params
#
# This class configures parameters for the puppet-newrelic module.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class newrelic::params {

  $manage_repo = true
  
  case $::osfamily {
    'RedHat': {
      $newrelic_package_name  = 'newrelic-sysmond'
      $newrelic_service_name  = 'newrelic-sysmond'
      $newrelic_php_package   = 'newrelic-php5'
      $newrelic_php_service   = 'newrelic-daemon'
      $newrelic_php_conf_dir  = ['/etc/php.d']
    }
    'Debian': {
      $newrelic_package_name  = 'newrelic-sysmond'
      $newrelic_service_name  = 'newrelic-sysmond'
      $newrelic_php_package   = 'newrelic-php5'
      $newrelic_php_service   = 'newrelic-daemon'

      case $::operatingsystem {
        'Debian': {
          case $::operatingsystemrelease {
            /^6/: {
              $newrelic_php_conf_dir  = ['/etc/php5/conf.d']
            }
            default: {
              $newrelic_php_conf_dir  = ['/etc/php5/mods-available']
            }
          }
        }
        'Ubuntu': {
          case $::operatingsystemrelease {
            /^(10|12)/: {
              $newrelic_php_conf_dir  = ['/etc/php5/conf.d']
            }
            default: {
              $newrelic_php_conf_dir  = ['/etc/php5/mods-available']
            }
          }
        }
        default: {
          $newrelic_php_conf_dir  = ['/etc/php5/conf.d']
        }
      }
    }
    'windows': {
      $bitness                          = regsubst($::architecture,'^x([\d]{2})','\1')
      $newrelic_package_name            = 'New Relic Server Monitor'
      $newrelic_service_name            = 'nrsvrmon'
      $temp_dir                         = 'C:/Windows/temp'
      $server_monitor_source            = 'http://download.newrelic.com/windows_server_monitor/release/'
      $newrelic_dotnet_conf_dir         = 'C:\\ProgramData\\New Relic\\.NET Agent'
      $newrelic_dotnet_package          = "New Relic .NET Agent (${bitness}-bit)"
      $newrelic_dotnet_source           = 'http://download.newrelic.com/dot_net_agent/release/'
      $newrelic_dotnet_application_name = 'My Application'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}")
    }
  }

}
