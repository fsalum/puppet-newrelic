# == Class: newrelic::infrastructure::windows
#
# [*staging_folder*]
#  Which folder to download the agent before installation.
#  Defaults to c:/temp
#
# [*source_url*]
#  URL to download the agent
#  Defaults to NR's URL
#
# [*download_proxy*]
#  Which proxy to use for downloading the agent
#  Defaults to undef
#
class newrelic::infrastructure::windows (
  $staging_folder = 'c:/temp',
  $source_url     = 'https://download.newrelic.com/infrastructure_agent/windows/newrelic-infra.msi',
  $download_proxy = undef,
){
  exec { 'Make sure staging directory exists':
    command  => "mkdir -p '${staging_folder}'",
    creates  => $staging_folder,
    provider => powershell,
  }->

  download_file { 'Download New Relic Infrastructure' :
    url                   => $source_url,
    destination_directory => $staging_folder,
    proxy_address         => $download_proxy,
  }->

  package { 'newrelic-infra':
    ensure => installed,
    source => "${staging_folder}/newrelic-infra.msi",
  }
}
