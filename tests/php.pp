# Install New Relic PHP Agent

node default {

  class { '::apache':
    mpm_module => 'prefork',
  }

  class { '::apache::mod::php': }

  class { '::newrelic':
    license_key      => '0123456789qwerty',
    enable_infra     => false,
    enable_php_agent => true,
  }

}
