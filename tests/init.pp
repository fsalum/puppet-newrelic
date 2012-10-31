node default {

  class { 'newrelic':
    newrelic_license_key        => '1234567891234567891234567891234567891234',
    newrelic_php                => true,
    newrelic_php_conf_appname   => 'Your PHP Application',
  }

}
