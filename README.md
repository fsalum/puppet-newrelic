# puppet-newrelic

[![Build Status](https://secure.travis-ci.org/claranet/puppet-newrelic.png?branch=master)](http://travis-ci.org/claranet/puppet-newrelic)
[![Puppet Forge](http://img.shields.io/puppetforge/v/Claranet/newrelic.svg)](https://forge.puppetlabs.com/Claranet/newrelic)

## Table of Contents

1. [Overview - What is the puppet-newrelic module?](#overview)
1. [Module Description - What does the module do?](#module-description)
1. [Setup - The basics of getting started with puppet-newrelic](#setup)
    * [What puppet-newrelic affects](#what-puppet-newrelic-affects)
    * [Beginning with puppet-newrelic](#beginning-with-registry)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Overview

This module manages and installs the New Relic Server Monitoring and PHP agents and is based on Felipe Salum's [puppet-newrelic](https://github.com/fsalum/puppet-newrelic) module.

### Puppet 3 Support

On 31st December 2016, support for Puppet 3.x was withdrawn. As as a result, **this module does not support Puppet 3**.

## Module Description

## Setup

### What puppet-newrelic affects

  * Adds the upstream NewRelic Yum/Apt repositories
  * Installs the NewRelic Server/Infrastructure agent and also the PHP or .NET agents

### Beginning with puppet-newrelic

By default, the module installs and configures the [NewRelic Infrastructure agent](https://docs.newrelic.com/docs/infrastructure/new-relic-infrastructure/installation/install-infrastructure-linux).

## Usage

To install the (deprecated) NewRelic Server Monitoring agent instead of the default NewRelic Infrastructure agent:

    class { '::newrelic':
      license_key   => 'your key here',
      enable_infra  => false,
      enable_server => true,
    }

To enable the PHP agent with default configuration:

    class { '::newrelic':
      license_key      => 'your key here',
      enable_php_agent => true,
    }

Further PHP agent configuration in Hiera:

     newrelic::agent::php::settings:
       appname: 'ACME PHP Application'
       daemon.loglevel: 'error'

### Advanced Usage Examples

To configure the PHP agent using Apache's `mod_php` (this assumes usage of Puppetlabs/Apache):

    class { '::apache': }
    class { '::apache::mod::php': }

    class { '::newrelic::agent::php':
      license_key  => 'your key',
      require      => Class['::apache::mod::php'],
      notify       => Service['httpd'],
    }

## Limitations

* When moving from NewRelic Server to NewRelic Infrastructure - the module only installs the new client, and does not clean up the old one

### Windows Support

Please note that Windows support is currently **untested**.

### Supported Operating Systems

* Debian/Ubuntu
* CentOS/RHEL

## Development

* Copyright (C) 2012 Felipe Salum <fsalum@gmail.com>
* Copyright (C) 2017 Claranet
* Distributed under the terms of the Apache License v2.0 - see LICENSE file for details.
