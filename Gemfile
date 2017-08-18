source "https://rubygems.org"

group :test do
  gem 'rake'
  gem 'puppet', ENV['PUPPET_VERSION'] || ' < 5.0.0'
  gem 'safe_yaml', '~> 1.0.4'
  gem 'puppet-lint'
  gem 'puppet-lint-absolute_classname-check'
  gem 'puppet-lint-alias-check'
  gem 'puppet-lint-package_ensure-check'
  gem 'puppet-lint-legacy_facts-check'
  gem 'puppet-lint-leading_zero-check'
  gem 'puppet-lint-global_resource-check'
  gem 'puppet-lint-file_source_rights-check'
  gem 'puppet-lint-file_ensure-check'
  gem 'puppet-lint-empty_string-check'
  gem 'puppet-lint-classes_and_types_beginning_with_digits-check'
  gem 'rspec-puppet', :git => 'https://github.com/rodjek/rspec-puppet.git'
  gem 'rspec-puppet-facts'
  gem 'puppet-syntax'
  gem 'puppetlabs_spec_helper', '< 2.0.0'
  gem 'metadata-json-lint', '1.1.0'
  gem 'json', '< 2.0.0'
  gem 'xmlrpc', :require => false if Gem::Version.new(RUBY_VERSION.dup) >= Gem::Version.new('2.4.0')
end

group :development do
  gem 'travis'
  gem 'travis-lint'
  gem 'vagrant-wrapper'
  gem 'puppet-blacksmith'
  gem 'guard-rake'
end

group :system_tests do
  gem 'beaker'
end
