class newrelic::params {

  case $::operatingsystem {
    'centos', 'redhat', 'fedora': { 
      $newrelic_package_name  = 'newrelic-sysmond'
      $newrelic_service_name  = 'newrelic-sysmond'
      $newrelic_php_package   = 'newrelic-php5'
      $newrelic_php_service   = 'newrelic-daemon'
      $newrelic_php_conf_dir  = '/etc/php.d'
      package { 'newrelic-repo-5-3.noarch':
        ensure => present,
        source => 'http://yum.newrelic.com/pub/newrelic/el5/x86_64/newrelic-repo-5-3.noarch.rpm',
        provider => rpm,
      }
    }
    'ubuntu', 'debian': {
      $newrelic_package_name  = 'newrelic-sysmond'
      $newrelic_service_name  = 'newrelic-sysmond'
      $newrelic_php_package   = 'newrelic-php5'
      $newrelic_php_service   = 'newrelic-daemon'
      $newrelic_php_conf_dir  = '/etc/php5/conf.d'
      include apt
      apt::source { 'newrelic':
        location    => 'http://apt.newrelic.com/debian/',
        repos       => 'newrelic non-free',
        key         => '548C16BF',
        key_source  => 'http://download.newrelic.com/548C16BF.gpg',
        include_src => false,
        release     => ' ',
      }
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}, module ${module_name} only support osfamily RedHat and Debian")
    }
  }

}
