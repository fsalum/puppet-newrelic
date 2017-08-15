# Install New Relic PHP Agent

node default {

  class { '::newrelic':
    license_key => '1234567890qwerty',
  }

}
