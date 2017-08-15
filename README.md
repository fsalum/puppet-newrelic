# puppet-newrelic

[![Build Status](https://secure.travis-ci.org/claranet/puppet-newrelic.png?branch=master)](http://travis-ci.org/claranet/puppet-newrelic)
[![Puppet Forge](http://img.shields.io/puppetforge/v/Claranet/newrelic.svg)](https://forge.puppetlabs.com/Claranet/newrelic)

## Table of Contents

1. [Overview - What is the puppet-newrelic module?](#overview)
1. [Module Description - What does the module do?](#module-description)
1. [Setup - The basics of getting started with puppet-newrelic](#setup)
    * [What puppet-newrelic affects](#what-puppet-newrelic-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with puppet-newrelic](#beginning-with-registry)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Overview

This module manages and installs the New Relic Server Monitoring and PHP agents and is based on Felipe Salum's [puppet-newrelic](https://github.com/fsalum/puppet-newrelic) module.

### Puppet 3 Support

On 31st December 2016, support for Puppet 3.x was withdrawn. As as a result, **this module does not support Puppet 3**.

## Module Description

## Setup

### What puppet-newrelic affects

### Setup Requirements

### Beginning with puppet-newrelic

There are a lot of parameters you can customize, check the `.pp` files and the [New Relic documentation](https://docs.newrelic.com/docs/php/php-agent-phpini-settings) to understand them.

## Usage

To install the Newrelic Server Monitoring and the PHP agent packages, include the following in your manifest file:

    node default {
         class {'newrelic::server::linux':
           newrelic_license_key => 'your license key here',
         }

         class {'newrelic::agent::php':
           newrelic_license_key  => 'your license key here',
           newrelic_ini_appname  => 'Your PHP Application',
         }
    }

To do the same for a Windows .Net host, include the following:

    node default {
         class {'newrelic::server::windows':
           newrelic_license_key => 'your license key here',
         }

         class {'newrelic::agent::dotnet':
           newrelic_license_key  => 'your license key here',
         }
    }

(Note that, while it is possible to specify a version of the .Net agent, caution should be excercised if doing this. Newrelic make only the last two releases available on http://download.newrelic.com/dot_net_agent/release/.)

If you use Ubuntu 14.04 and php5-fpm you can pass an array of directories for PHP ini files:

         class {'newrelic::agent::php':
           newrelic_license_key  => 'your license key here',
           newrelic_ini_appname  => 'Your PHP Application',
           newrelic_php_conf_dir => ['/etc/php5/mods-available/conf.d','/etc/php5/fpm/conf.d'],
         }

## Reference

Mandatory parameters:

* newrelic_license_key

### Classes

## Limitations

### Supported Operating Systems

 * Debian/Ubuntu
 * CentOS/RHEL
 * Windows (currently untested)

## Development

* Copyright (C) 2012 Felipe Salum <fsalum@gmail.com>
* Copyright (C) 2017 Claranet
* Distributed under the terms of the Apache License v2.0 - see LICENSE file for details.
