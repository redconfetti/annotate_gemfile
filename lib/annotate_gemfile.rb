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

####
# Bundler.definition
#
#
# Bundler.definition.dependencies[0]
# => Gem::Dependency.new("rails", Gem::Requirement.new(["= 4.0.0"]), :runtime)

# Bundler::Definition.build(gemfile, lockfile, unlock)
# Checks for Gemfile present, then delegates with call to Dsl.evaluate(gemfile, lockfile, unlock)
#
# Bundler::Dsl loads contents of Gemfile like so:
# Bundler.read_file(gemfile.to_s)
# This loads the whole file as a string, then executes it.

# After evaluating the Gemfile, a call is made to generate a definition.
# @rubygems_sources is populated with this object:
# #<Bundler::Source::Rubygems:0x007f910cb45858 @options={}, @remotes=[#<URI::HTTPS:0x007f910cb55848 URL:https://rubygems.org/>], @fetchers={}, @dependency_names=[], @allow_remote=false, @allow_cached=false, @caches=[#<Pathname:/Users/redconfetti/Sites/cvirtual/vendor/cache>, "/Users/redconfetti/.rvm/gems/ruby-2.0.0-p247@cvirtual/cache", "/Users/redconfetti/.rvm/gems/ruby-2.0.0-p247@global/cache"]>
# @dependencies is populated with this array:
# [
#   <Bundler::Dependency type=:runtime name="rails" requirements="= 4.0.0">, <Bundler::Dependency type=:runtime name="sqlite3" requirements=">= 0">,
#   <Bundler::Dependency type=:runtime name="jquery-rails" requirements=">= 0">, <Bundler::Dependency type=:runtime name="jquery-ui-rails" requirements=">= 0">,
#   <Bundler::Dependency type=:runtime name="devise" requirements=">= 0">, <Bundler::Dependency type=:runtime name="turbolinks" requirements=">= 0">]
# So the sources, the dependencies obtained from the Gemfile, the path to the Gemfile.lock file,
# and some sort of 'unlock' hash all get passed to Bundler::DSL.to_definition
