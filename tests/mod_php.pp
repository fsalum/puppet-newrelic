node default {

  # == Apache

  class { '::apache':
    mpm_module => 'prefork',
  }

  class { '::apache::mod::php': }

  # == NewRelic

  class { '::newrelic::agent::php':
    license_key  => '3522b44f4c3f89c8566d5781bac6e0bb7dedab7z',
    require      => Class['::apache::mod::php'],
    notify       => Service['httpd'],
    ini_settings => {'appname' => "Test Application: ${facts[networking][hostname]}"},
  }

  # == phpinfo() page

  if $facts['os']['family'] == 'Debian' {
    if $facts['os']['release']['major'] == '7' {
      $apache_webroot = '/var/www'
    } else {
      $apache_webroot = '/var/www/html'
    }
  } else {
    $apache_webroot = '/var/www/html'
  }

  file { "${apache_webroot}/index.php":
    ensure  => file,
    content => "<?php phpinfo(); ?>\n",
    require => Package['httpd'],
  }

  file { "${apache_webroot}/index.html":
    ensure  => absent,
    require => Package['httpd'],
  }

}
