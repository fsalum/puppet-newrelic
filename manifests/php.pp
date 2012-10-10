class newrelic::php (
  $newrelic_license_key,
  $newrelic_php_package,
  $newrelic_php_service,
  $newrelic_php_conf_dir,
  $newrelic_php_conf_appname,
  $newrelic_php_conf_enabled,
  $newrelic_php_conf_logfile,
  $newrelic_php_conf_loglevel,
  $newrelic_php_conf_browser,
  $newrelic_php_conf_transaction,
  $newrelic_php_conf_dberrors,
  $newrelic_php_conf_transactionrecordsql,
  $newrelic_php_conf_captureparams,
) {

  package { $newrelic_php_package:
    ensure  => $newrelic_php_package_ensure,
    notify  => Service[$newrelic_php_service],
  }

  service { $newrelic_php_service:
    ensure     => $newrelic_php_service_ensure,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => Exec['/usr/bin/newrelic-install'],
  }

  exec { '/usr/bin/newrelic-install':
    path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    command     => "/usr/bin/newrelic-install purge ; NR_INSTALL_SILENT=yes, NR_INSTALL_KEY=$newrelic_license_key /usr/bin/newrelic-install install",
    provider    => 'shell',
    user        => 'root',
    group       => 'root',
    unless      => "cat /etc/newrelic/newrelic.cfg | grep $newrelic_license_key",
    require     => Package[$newrelic_php_package],
    notify      => Service[$newrelic_php_service],
  }

  file { 'newrelic.ini':
    path    => "$newrelic_php_conf_dir/newrelic.ini",
    content => template('newrelic/newrelic.ini.erb'),
    require => Exec['/usr/bin/newrelic-install'],
  }

}  
