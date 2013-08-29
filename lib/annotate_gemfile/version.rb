# encoding: utf-8

module AnnotateGemfile
  class Version
    MAJOR = 0
    MINOR = 1
    PATCH = 0
    BUILD = nil

    STRING = [MAJOR, MINOR, PATCH, BUILD].compact.join('.');
  end
end # AnnotateGemfile