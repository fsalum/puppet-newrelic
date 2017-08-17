node default {

  $webroot = '/usr/share/nginx/html'

  # == PHP-FPM

  class { '::phpfpm':
      poold_purge => true,
  }

  ::phpfpm::pool { 'main': }

  # == Nginx

  class { '::nginx':
    server_purge => true,
    confd_purge  =>  true,
  }

  ::nginx::resource::server { 'default':
    index_files          => ['index.php'],
    use_default_location => false,
    www_root             => $webroot,
  }

  ::nginx::resource::location { 'webroot':
    location => '~ \.php$',
    server   => 'default',
    fastcgi  => '127.0.0.1:9000',
  }

  # == NewRelic

  class { '::newrelic::agent::php':
    license_key  => '3522b44f4c3f89c8566d5781bac6e0bb7dedab7z',
    require      => Class['::phpfpm'],
    notify       => Class['::phpfpm::service'],
    ini_settings => {'appname' => "Test Application: ${facts[networking][hostname]}"},
  }

  # == phpinfo() page

  file { "${webroot}/index.php":
    ensure  => file,
    content => "<?php phpinfo(); ?>\n",
    require => Package['nginx'],
  }

  file { "${webroot}/index.html":
    ensure  => absent,
    require => Package['nginx'],
  }

}
