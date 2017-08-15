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

  * Adds the upstream NewRelic Yum/Apt repositories
  * Installs the NewRelic Server/Infrastructure agent and also the PHP or .NET agents

### Beginning with puppet-newrelic

By default, the module installs and configures the [NewRelic Infrastructure agent](https://docs.newrelic.com/docs/infrastructure/new-relic-infrastructure/installation/install-infrastructure-linux).

## Usage

To install the (deprecated) NewRelic Server Monitoring agent instead of the default NewRelic Infrastructure agent:

    class { 'newrelic':
      license_key   => 'your key here',
      enable_infra  => false,
      enable_server => true,
    }

## Reference

Mandatory parameters:

* `license_key`

There are also a lot of parameters for the Server and PHP agents. Please check the manifest files and the [New Relic documentation](https://docs.newrelic.com/docs/php/php-agent-phpini-settings) to understand them.

### Classes

## Limitations

* Moving from NewRelic Server to NewRelic Infrastructure - the module only installs the new client, and does not clean up the old one

### Supported Operating Systems

* Debian/Ubuntu
* CentOS/RHEL
* Windows (currently untested)

## Development

* Copyright (C) 2012 Felipe Salum <fsalum@gmail.com>
* Copyright (C) 2017 Claranet
* Distributed under the terms of the Apache License v2.0 - see LICENSE file for details.
