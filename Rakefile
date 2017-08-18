require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'puppet-syntax/tasks/puppet-syntax'

# These gems aren't always present, for instance on Travis
begin
  require 'puppet_blacksmith/rake_tasks'
rescue LoadError
end

Rake::Task[:lint].clear

exclude_paths = [
  "bundle/**/*",
  "pkg/**/*",
  "vendor/**/*",
  "spec/**/*",
]

PuppetSyntax.exclude_paths = exclude_paths

PuppetLint.configuration.relative = true
PuppetLint.configuration.fail_on_warnings = true
PuppetLint.configuration.ignore_paths = exclude_paths
PuppetLint::RakeTask.new :lint do |config|
  config.ignore_paths = exclude_paths
end

desc "Populate CONTRIBUTORS file"
task :contributors do
  system("git log --format='%aN' | sort -u > CONTRIBUTORS")
end

desc "Run syntax, lint, and spec tests."
task :test => [
  :metadata_lint,
  :syntax,
  :lint,
  :spec
]
