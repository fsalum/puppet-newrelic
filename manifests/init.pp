# == Class: newrelic
#
# Installs and configures NewRelic server monitoring and Infrastructure agents,
# as well as the PHP and/or .NET agents.
#
# === Parameters
#
# [*license_key*]
#   NewRelic API license key (String)
#
# [*enable_infra*]
#   Enables installation of the Infrastructure Agent
#   Default: true (Boolean)
#
# [*enable_server*]
#   Enables installation of the Server Agent
#   Default: false (Boolean)
#
# [*enable_php_agent*]
#   Enables installation of the PHP Agent
#   Default: false (Boolean)
#
# [*enable_dotnet_agent*]
#   Enables installation of the .NET Agent
#   Default: false (Boolean)
#
# [*manage_repo*]
#   Whether to install the NewRelic OS repositories
#   Default: Varies depending on OS (Boolean)
#
# === Examples
#
# class { '::newrelic':
#   enable_server => true,
#   enable_infra  => false,
#   enable_php    => true,
# }
#
# === Authors
#
# Felipe Salum <fsalum@gmail.com>
# Craig Watson <craig.watson@claranet.uk>
#
# === Copyright
#
# Copyright 2012 Felipe Salum
# Copyright 2017 Claranet
#
class newrelic (
  String  $license_key,
  Boolean $manage_repo         = $::newrelic::params::manage_repo,
  Boolean $enable_infra        = true,
  Boolean $enable_server       = false,
  Boolean $enable_php_agent    = false,
  Boolean $enable_dotnet_agent = false,
) inherits newrelic::params {

  if length($license_key) != 40 {
    warning('Your license key is not 40 characters!')
  }

  if $enable_infra == true {
    class { '::newrelic::infra':
      license_key => $license_key,
      manage_repo => $manage_repo,
    }
  }

  if $enable_server == true {
    warning('Use of newrelic::server is deprecated and will be removed in a future release. Please use newrelic::infra instead.')
    if $facts['os']['family'] == 'Windows' {
      class { '::newrelic::server::windows': }
    } else {
      class { '::newrelic::server::linux':
        license_key => $license_key,
        manage_repo => $manage_repo,
      }
    }
  }

  if $enable_php_agent == true {
    class { '::newrelic::agent::php': }
  }


    # == FIXME Untested below here

  if $enable_dotnet_agent == true {
    class { '::newrelic::agent::dotnet': }
  }
}
