node default {

  class { '::apache':
    mpm_module => 'prefork',
  }

  class { '::apache::mod::php': }

  class { '::newrelic::agent::php':
    license_key      => '3522b44f4c3f89c8566d5781bac6e0bb7dedab7z',
    require          => Class['::apache::mod::php'],
    symlink_conf_dir => ['/etc/php5/apache2/conf.d','/etc/php5/cli/conf.d'],
    notify           => Service['httpd'],
    ini_settings     => {
      'appname' => 'Test Application',
    },
  }

  file { '/var/www/html/index.php':
    ensure  => file,
    owner   => 'www-data',
    group   => 'www-data',
    mode    => '0644',
    content => "<?php phpinfo(); ?>\n",
    require => Package['httpd'],
  }

}
