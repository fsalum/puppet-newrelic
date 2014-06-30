Newrelic Module for Puppet
==========================
[![Build Status](https://secure.travis-ci.org/fsalum/puppet-newrelic.png)](http://travis-ci.org/fsalum/puppet-newrelic)

This module manages and installs the New Relic Server Monitoring and PHP agents.  

Supported systems: Debian and RHEL osfamily Linux.

Operating System
----------------

Tested on CentOS, Debian and Ubuntu.

IMPORTANT
---------

Module version 4.x was refactored. A lot of parameters were added, removed, renamed or changed.

Review all the parameters you use before deploying this module in production.

Quick Start
-----------

To install the Newrelic Server Monitoring and the PHP agent packages, include the following in your manifest file:

    node default {
         newrelic::server {
           'srvXYZ':
             newrelic_license_key => 'your license key here',
         }

         newrelic::php {
           'appXYZ':
             newrelic_license_key  => 'your license key here',
             newrelic_ini_appname  => 'Your PHP Application',
         }
    }

If you use Ubuntu 14.04 and php5-fpm you can pass an array of directories for PHP ini files:

         newrelic::php {
           'appXYZ':
             newrelic_license_key  => 'your license key here',
             newrelic_ini_appname  => 'Your PHP Application',
             newrelic_php_conf_dir => ['/etc/php5/apache2/conf.d','/etc/php5/fpm/conf.d'],
         }

Parameters
----------

There are a lot of parameters you can customize, check the `.pp` files and the [New Relic documentation](https://docs.newrelic.com/docs/php/php-agent-phpini-settings) to understand them.

Mandatory parameters:

* newrelic_license_key

Copyright and License
---------------------

Copyright (C) 2012 Felipe Salum

Felipe Salum can be contacted at: fsalum@gmail.com

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
