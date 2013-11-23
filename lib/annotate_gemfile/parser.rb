# encoding: utf-8

module AnnotateGemfile
  class Parser

    attr_reader :gemfile_source

    def initialize(gemfile_path)
      load_gemfile(gemfile_path)
    end
    
    def load_gemfile(filepath)
      @gemfile_source = IO.read(filepath)
    end

  end # Parser
end # AnnotateGemfile