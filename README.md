Newrelic Module for Puppet
==========================
[![Build Status](https://secure.travis-ci.org/fsalum/puppet-newrelic.png)](http://travis-ci.org/fsalum/puppet-newrelic)

This module manages and installs the New Relic Server Monitoring and PHP agents.  

Supported systems: Debian and RHEL osfamily Linux.

Operating System
----------------

Tested on CentOS 6.3 and Debian Squeeze.

IMPORTANT
---------

If you were using the previous version of this module `0.0.1` you need to change
how you declare the class because I'm now using defined resource types and I have
split the Server Monitoring and PHP Agent classes to be easy to maintain.

All the parameters are still the same and new parameters were included.

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
             newrelic_license_key      => 'your license key here',
             newrelic_php_conf_appname => 'Your PHP Application',
         }
    } 

Parameters
----------

There are a lot of parameters you can customize, check the `.pp` files and the New Relic documentation to understand them.

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
