# Class: newrelic::infra::linux
# =============================
#
# This class install and start the New Relic Infrastrucure Agent which replaces the deprecated server class
#
# Parameters
# ----------
#
# * `newrelic_license_key`
#   The accounts license key as issued by New Relic
# * `newrelic_manage_repo`
#   Boolean flag to configure the New Relic repo
#
class newrelic::infra::linux (
  $newrelic_license_key = undef,
  $newrelic_manage_repo = true,
) {

  if ! $newrelic_license_key {
    fail('You must specify a valid License Key.')
  }

  if $newrelic_manage_repo {

    case $facts['os']['family'] {
      'redhat': {
        yumrepo { 'newrelic-infra':
          ensure        => 'present',
          descr         => 'New Relic Infrastructure',
          baseurl       => "http://download.newrelic.com/infrastructure_agent/linux/yum/el/${operatingsystemmajrelease}/x86_64",
          gpgkey        => 'http://download.newrelic.com/infrastructure_agent/gpg/newrelic-infra.gpg',
          gpgcheck      => '1',
          repo_gpgcheck => '1',
        }
      }
      'debian': {
        err('Debian based OSes are currently not supported.')
      }
      default: {
        err('Non supported OS found.')
      }
    }
  }

  file { '/etc/newrelic-infra.yml':
    ensure  => file,
    content => template('newrelic/newrelic-infra.yaml.erb'),
    notify  => Service['newrelic-infra']
  }

  package { 'newrelic-infra':
    ensure  => present,
    require => File['/etc/newrelic-infra.yml']
  }

  service { 'newrelic-infra':
    ensure  => running,
    require => Package['newrelic-infra']
  }

}
