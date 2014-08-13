#!/usr/bin/env rake
#
# See http://technology.customink.com/blog/2012/06/04/mvt-foodcritic-and-travis-ci/
#
require 'rspec/core/rake_task'

desc 'Runs foodcritic linter'
task :foodcritic do
  excluded_rules = %w{FC003 FC015 FC009 FC023}
  tags = excluded_rules.map { |r| "--tags ~#{r}" }
  sh "foodcritic -C #{tags.join(" ")} --epic-fail any ."
end

task :default => %w{foodcritic}
#task :spec => :test

#RSpec::Core::RakeTask.new(:test)
