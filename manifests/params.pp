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
      $newrelic_key           = '548C16BF'
      $newrelic_php_service   = 'newrelic-daemon'
      apt::source { 'newrelic':
        location    => 'http://apt.newrelic.com/debian/',
        repos       => 'non-free',
        key         => $newrelic_key,
        key_source  => 'https://download.newrelic.com/548C16BF.gpg',
        include_src => false,
        release     => 'newrelic',
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
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}, module ${module_name} only support osfamily RedHat and Debian")
    }
  }

}
