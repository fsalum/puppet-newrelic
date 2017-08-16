node default {

  class { '::apache':
    mpm_module => 'prefork',
  }

  class { '::apache::mod::php': }

  class { '::newrelic::agent::php':
    license_key   => '3522b44f4c3f89c8566d5781bac6e0bb7dedab7z',
    daemon_enable => false,
    require       => Class['::apache::mod::php'],
    ini_settings  => {
      'appname' => 'Test Application2',
    },
  }

}
