# encoding: utf-8

module AnnotateGemfile
  class Parser

    def self.datetime_string
      Time.now.strftime("%m-%d-%y-%H_%M_%S")
    end

    def initialize(gemfile_path)
      load_gemfile(gemfile_path)
    end

    def load_gemfile(filepath)
      raise IOError, "Gemfile not found at #{filepath}" unless File.exist?(filepath)
      @gemfile_contents = IO.read(filepath)
    end

    def remove_commented_lines
      @gemfile_contents.gsub!(/^\s*#.*\n+/,'')
    end

    def load_gemfile_array
      raise RuntimeError, "Gemfile contents not present" if @gemfile_contents.nil?
      @gemfile_array = @gemfile_contents.lines.to_a
    end

  end # Parser
end # AnnotateGemfile