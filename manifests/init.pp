# == Class: newrelic
#
# This class installs and configures NewRelic server monitoring and NewRelic PHP agent.
#
# === Parameters
#
# === Variables
#
# === Examples
#
# === Authors
#
# Felipe Salum <fsalum@gmail.com>
#
# === Copyright
#
# Copyright 2012 Felipe Salum, unless otherwise noted.
#
class newrelic (
  $manage_repo = $newrelic::params::manage_repo,
) inherits newrelic::params {

  include newrelic::repo

}
