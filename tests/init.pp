# Install New Relic Server Monitoring

node default {

  class {'newrelic::server::linux':
    newrelic_license_key    => '',
    newrelic_package_ensure => 'latest',
    newrelic_service_ensure => 'running',
  }

}
