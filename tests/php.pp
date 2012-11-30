# Install New Relic PHP Agent

node default {

  newrelic::server {
    'srvXYZ':
      newrelic_license_key => 'your license key here',
  }

  newrelic::php {
    'appXYZ':
      newrelic_license_key      => 'your license key here',
      newrelic_php_conf_appname => 'Your PHP Application',
  }

}
