node default {

  class { '::apache':
    mpm_module => 'prefork',
  }

  class { '::apache::mod::php': }

  class { '::newrelic':
    license_key      => '3522b44f4c3f89c8566d5781bac6e0bb7dedab7z',
    enable_infra     => false,
    enable_php_agent => true,
    require          => Class['::apache::mod::php']
  }

}
