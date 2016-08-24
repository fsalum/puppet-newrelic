# This module should not be used directly. It is used by newrelicnew::php.
define newrelicnew::php::newrelic_ini (
  $newrelic_license_key,
  $exec_path,
) {

  exec { "/usr/bin/newrelic-install ${name}":
    path     => $exec_path,
    command  => "/usr/bin/newrelic-install purge ; NR_INSTALL_SILENT=yes, NR_INSTALL_KEY=${newrelic_license_key} /usr/bin/newrelic-install install",
    provider => 'shell',
    user     => 'root',
    group    => 'root',
    unless   => "grep ${newrelic_license_key} ${name}/newrelic.ini",
  }

  file { "${name}/20-newrelic.ini":
    path    => "${name}/20-newrelic.ini",
    content => template('newrelicnew/newrelic.ini.erb'),
    require => Exec["/usr/bin/newrelic-install ${name}"],
  }

  file { "${name}/newrelic.ini":
    ensure => absent,
  }

}
