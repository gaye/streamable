#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

begin
  require File.expand_path('../config/application', __FILE__)
  require 'rspec/core/rake_task'
  require 'ci/reporter/rake/rspec'

  Streamable::Application.load_tasks

  RSpec::Core::RakeTask.new(:all => ["ci:setup:rspec"]) do |t|
    t.pattern = '**/*_spec.rb'

  end
rescue LoadError
end
