Newrelic Module for Puppet
===========================
[![Build Status](https://secure.travis-ci.org/fsalum/puppet-newrelic.png)](http://travis-ci.org/fsalum/puppet-newrelic)

This module manages and installs the New Relic Server Monitoring and PHP agents.

Quick Start
-----------

To install the Newrelic Server Monitoring and the PHP agent packages, include the following in your manifest file:

    node default {
         class { newrelic:
           newrelic_license_key        => 'YOUR LICENSE KEY HERE',
           newrelic_php                => true,
           newrelic_php_conf_appname   => 'Your PHP Application Name Here',
    }

Parameters
----------

You can also set some extra parameters to enable or disable a few options:

* `newrelic_service_ensure`

   Specify the service running state. Defaults to 'running'. Possible value is 'stopped'.

* `newrelic_package_ensure`
 
   Specify the package update state. Defaults to 'present'. Possible value is 'latest'.

* `newrelic_license_key`
 
   Specify your Newrelic License Key.

* `newrelic_php`
 
   If set to true will install and configure Newrelic PHP agent. Defaults to false.

* `newrelic_php_package_ensure`
 
   Specific the Newrelic PHP package update state. Defaults to 'present'. Possible value is 'latest'.

* `newrelic_php_service_ensure`
 
   Specify the Newrelic PHP service running state. Defaults to 'running'. Possible value is 'stopped'.

* `newrelic_php_conf_appname`
 
   Sets the name of the application as it will be seen in the New Relic UI

* `newrelic_php_conf_enabled`
 
   By default the New Relic PHP agent is enabled for all directories. To disable set it to '0'.

* `newrelic_php_conf_transaction`
 
   Turns on the "top 100 slowest calls" tracer. To enable set it to '1'.

* `newrelic_php_conf_logfile`
 
   This identifies the file name for logging messages.

* `newrelic_php_conf_loglevel`
 
   Sets the level of detail of messages sent to the log file. Possible values: error, warning, info, verbose, debug, verbosedebug.

* `newrelic_php_conf_browser`
 
   This enables auto-insertion of the JavaScript fragments for browser monitoring. To disable set it to '0'.

* `newrelic_php_conf_dberrors`
 
   It causes MySQL errors from all instrumented MySQL calls to be reported to New Relic. To enable set it to '1'.

* `newrelic_php_conf_transactionrecordsql`
 
   When recording transaction traces internally, the full SQL for slow SQL calls is recorded. Possible values: off, raw, obfuscate
.

* `newrelic_php_conf_captureparams`
 
   This will enable the display of parameters passed to a PHP script via the URL. To enable set it to '1'.

Author
------
Felipe Salum <fsalum@gmail.com>