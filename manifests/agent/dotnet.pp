# Class: newrelic::agent::dotnet
#
# This class install the New Relic .Net Agent
#
# Parameters:
#
# [*newrelic_dotnet_package_ensure*]
#   Specific the Newrelic .Net package update state. Defaults to 'present'. Possible values are specific versions of the agent.
#   Note that, if you specifiy a specific version, you will need to keep this regularly updated, as NewRelic only retain the last two releases on their download site.
#
# [*newrelic_dotnet_cfgfile_ensure*]
#   Specify the Newrelic daemon cfg file state. Change to absent for agent startup mode. Defaults to 'present'. Possible value is 'absent'.
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
#  class {'newrelic::agent::dotnet':
#      newrelic_license_key           => 'your license key here',
#      newrelic_dotnet_package_ensure => 'latest',
#    }
#
# If no parameters are set it will use the newrelic.config defaults
#
# For detailed explanation about the parameters below see: https://docs.newrelic.com/docs/php/php-agent-phpini-settings
#
class newrelic::agent::dotnet (
  $newrelic_dotnet_package_ensure                        = 'present',
  $newrelic_dotnet_conf_dir                              = $::newrelic::params::newrelic_dotnet_conf_dir,
  $newrelic_dotnet_package                               = $::newrelic::params::newrelic_dotnet_package,
  $newrelic_license_key                                  = undef,
  $newrelic_daemon_cfgfile_ensure                        = 'present',
  $temp_dir                                              = $::newrelic::params::temp_dir ,
  $newrelic_dotnet_source                                = $::newrelic::params::newrelic_dotnet_source,
  $newrelic_application_name                             = $::newrelic::params::newrelic_application_name,
) inherits ::newrelic {

  if ! $newrelic_license_key {
    fail('You must specify a valid License Key.')
  }
  
  case $newrelic_dotnet_package_ensure {
    'absent':   {
      $package_source = false
    }
    'present','installed':  {
      $package_source   = "${newrelic_dotnet_source}/NewRelicDotNetAgent_${::architecture}.msi"
      $destination_file = "NewRelicDotNetAgent_${::architecture}.msi"
    }
    'latest':   {
      fail("'latest' is not a valid value for this package, as we have no way of determining which version is the latest one. You can specify a specific version, though.")
    }
    default:    {
      $package_source   = "${newrelic_dotnet_source}/NewRelicDotNetAgent_${::architecture}_${newrelic_dotnet_package_ensure}.msi"
      $destination_file = "NewRelicDotNetAgent_${::architecture}_${newrelic_dotnet_package_ensure}.msi"
    }
  }
  
  if $package_source {
    download_file {$destination_file:
      url                   => $package_source,
      destination_directory => $temp_dir,
      destination_file      => $destination_file,
      before                => Package[$newrelic_dotnet_package],
    }
  }

  package { $newrelic_dotnet_package:
    ensure  => $newrelic_dotnet_package_ensure,
    source  => "${temp_dir}\\${destination_file}",
    require => Class['newrelic::params'],
  } ->
  file { "${newrelic_dotnet_conf_dir}\\newrelic.config":
    ensure  => $newrelic_daemon_cfgfile_ensure,
    content => template('newrelic/newrelic.config.erb'),
    notify  => Exec["iisreset"],
  }

  exec { 'iisreset':
    path        => 'C:/WINDOWS/System32',
    refreshonly => true
  }
}
