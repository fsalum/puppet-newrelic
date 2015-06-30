# Class: newrelicnew::params
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
class newrelicnew::params {

  case $::osfamily {
    'RedHat': {
      $newrelic_package_name  = 'newrelic-sysmond'
      $newrelic_service_name  = 'newrelic-sysmond'
      $newrelic_php_package   = 'newrelic-php5'
      $newrelic_php_service   = 'newrelic-daemon'
      $newrelic_php_conf_dir  = ['/etc/php.d']
      package { 'newrelic-repo-5-3.noarch':
        ensure   => present,
        source   => 'http://yum.newrelic.com/pub/newrelic/el5/x86_64/newrelic-repo-5-3.noarch.rpm',
        provider => rpm,
      }
    }
    'Debian': {
      $newrelic_package_name  = 'newrelic-sysmond'
      $newrelic_service_name  = 'newrelic-sysmond'
      $newrelic_php_package   = 'newrelic-php5'
      $newrelic_php_service   = 'newrelic-daemon'
      apt::source { 'newrelic':
        location => 'http://apt.newrelic.com/debian/',
        repos    => 'non-free',
        key      => {
          id         => 'B60A3EC9BC013B9C23790EC8B31B29E5548C16BF',
          key_source => 'https://download.newrelic.com/548C16BF.gpg',
        },
        include  => {
          src => false,
        },
        release  => 'newrelic',
      }
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
      $bitness                        = regsubst($::architecture,'^x([\d]{2})','\1')
      $newrelic_package_name          = 'New Relic Server Monitor'
      $newrelic_service_name          = 'nrsvrmon'
      $temp_dir                       = 'C:/Windows/temp'
      $server_monitor_source          = 'http://download.newrelic.com/windows_server_monitor/release/'
      $newrelic_dotnet_conf_dir       = 'C:\\ProgramData\\New Relic\\.NET Agent'
      $newrelic_dotnet_package        = "New Relic .NET Agent (${bitness}-bit)"
      $newrelic_dotnet_source         = 'http://download.newrelic.com/dot_net_agent/release/'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}")
    }
  }

}
