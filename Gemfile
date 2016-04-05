source ENV['GEM_SOURCE'] || "https://rubygems.org"

group :development, :test do
  gem 'rspec-puppet',           :require => false
  gem 'puppetlabs_spec_helper', :require => false
  gem 'puppet_facts',           :require => false
  gem 'metadata-json-lint',     :require => false
end

# Older versions of ruby are not compatible with the current rake gem
if rakeversion = ENV['RAKE_GEM_VERSION']
  gem 'rake', rakeversion, :require => false
else
  gem 'rake', :require => false
end

if facterversion = ENV['FACTER_GEM_VERSION']
  gem 'facter', facterversion, :require => false
else
  gem 'facter', :require => false
end

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', :require => false
end

# vim:ft=ruby
