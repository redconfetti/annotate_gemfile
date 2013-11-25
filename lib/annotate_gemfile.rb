# encoding: utf-8
require 'rubygems'
require 'bundler'

module AnnotateGemfile

  autoload :Version,    'annotate_gemfile/version'
  autoload :Parser,     'annotate_gemfile/parser'

  class Annotator
    attr_accessor :some_property
    def initialize(path)
      @gemfile_path = path
    end

    def bundler_details
      Gem::Dependency.new("rails", Gem::Requirement.new(["= 4.0.0"]), :runtime).to_s
    end
  end

end
