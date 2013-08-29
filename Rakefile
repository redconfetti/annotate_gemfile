# encoding: utf-8

# Gem development tasks
require "bundler/gem_tasks"

# Import Rspec rake tasks, with spec as default
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)
task :default => :spec

namespace :annotate do
  desc "Annotates Gemfile"
  task :gemfile do
    gemfile_path = File.dirname(__FILE__) + '/Gemfile'    
    raise RuntimeError, "Gemfile not found at #{gemfile_path}" unless File.exists?(gemfile_path)
  end
end