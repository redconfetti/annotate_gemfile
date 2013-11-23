# encoding: utf-8

# Gem development tasks
require "bundler/gem_tasks"

# Import Rspec rake tasks, with spec as default
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)
task :default => :spec

begin
  require 'bundler'
rescue LoadError => e
  warn("warning: Could not load bundler: #{e}")
  warn("         Some rake tasks will not be defined")
else
  Bundler::GemHelper.install_tasks
end

namespace :annotate do
  desc "Annotates Gemfile"
  task :gemfile do
    require 'rubygems'
    require 'annotate_gemfile'
    gemfile_path = File.dirname(__FILE__) + '/Gemfile'    
    raise RuntimeError, "Gemfile not found at #{gemfile_path}" unless File.exists?(gemfile_path)
    puts "AnnotateGemfile Version: #{AnnotateGemfile::Version::STRING}"
    puts "Gemfile Path: #{gemfile_path.inspect}"

    annotater = AnnotateGemfile::Annotator.new(gemfile_path)
    parser = AnnotateGemfile::Parser.new(gemfile_path)
    puts "AnnotateGemfile::Parser: #{parser.inspect}"
    puts "AnnotateGemfile::Annotator: #{annotater.inspect}"

    puts "Annotation Inspect:\n--------\n#{annotater.bundler_details.inspect}\n--------"

  end
end