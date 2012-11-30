Newrelic Module for Puppet
==========================
[![Build Status](https://secure.travis-ci.org/fsalum/puppet-newrelic.png)](http://travis-ci.org/fsalum/puppet-newrelic)

This module manages and installs the New Relic Server Monitoring and PHP agents.

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

Author
------
Felipe Salum <fsalum@gmail.com>
