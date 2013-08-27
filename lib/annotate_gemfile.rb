# encoding: utf-8

require 'annotate_gemfile/version'

module AnnotateGemfile
  
  class Annotator
    def initialize(path)
      @gemfile_path = path
    end
  end

end