# This module should not be used directly. It is used by newrelic::php.
define newrelic::php::newrelic_ini (
  $newrelic_license_key
) {

  exec { "/usr/bin/newrelic-install ${name}":
    path     => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    command  => "/usr/bin/newrelic-install purge ; NR_INSTALL_SILENT=yes, NR_INSTALL_KEY=${newrelic_license_key} /usr/bin/newrelic-install install",
    provider => 'shell',
    user     => 'root',
    group    => 'root',
    unless   => "grep ${newrelic_license_key} ${name}/newrelic.ini",
  }

  file { "${name}/newrelic.ini":
    path    => "${name}/newrelic.ini",
    content => template('newrelic/newrelic.ini.erb'),
    require => Exec["/usr/bin/newrelic-install ${name}"],
  }

}
