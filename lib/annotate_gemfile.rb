# encoding: utf-8
require 'rubygems'
require 'bundler'

module AnnotateGemfile

  autoload :Version,    'annotate_gemfile/version'
  autoload :Parser,     'annotate_gemfile/parser'

  class Annotator

    def self.datetime_string
      Time.now.strftime("%m-%d-%y-%H_%M_%S")
    end

    def initialize(path)
      @gemfile_path = path
    end

    def backup_gemfile
      @gemfile_path_backup = @gemfile_path + "-backup-#{self.class.datetime_string}"
      FileUtils.copy_file(@gemfile_path, @gemfile_path_backup)
      @gemfile_path_backup
    end

  end

end
