# Install New Relic Server Monitoring

node default {

  newrelic::server {
    'webXYZ-app':
      newrelic_license_key    => 'your license key here',
      newrelic_package_ensure => 'latest',
      newrelic_service_ensure => 'running',
  }

}
