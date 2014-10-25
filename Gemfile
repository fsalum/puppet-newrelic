source ENV['GEM_SOURCE'] || "https://rubygems.org"

puppetversion = ENV.key?('PUPPET_VERSION') ? "= #{ENV['PUPPET_VERSION']}" : ['>= 2.7']

gem 'rake'
gem 'puppet-lint'
gem 'puppet', puppetversion
