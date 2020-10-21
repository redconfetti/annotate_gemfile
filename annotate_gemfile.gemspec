# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'annotate_gemfile/version'

Gem::Specification.new do |spec|
  spec.name             = "annotate_gemfile"
  spec.version          = AnnotateGemfile::Version::STRING
  spec.authors          = ["Jason Miller"]
  spec.email            = ["jason@redconfetti.com"]
  spec.description      = %q{Adds Github name, description, URL above each gem declaration in your Gemfile.}
  spec.summary          = %q{Adds Github name, description, URL above each gem declaration in your Gemfile.}
  spec.homepage         = ""
  spec.license          = "MIT"

  spec.files            = `git ls-files`.split($/)
  spec.executables      = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files       = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths    = ["lib"]

  # https://github.com/rspec/rspec
  spec.add_development_dependency "rspec", "~> 3.9.0"

  # https://github.com/rspec/rspec-its
  spec.add_development_dependency "rspec-its", "~> 1.3.0"

  # https://github.com/vcr/vcr
  spec.add_development_dependency "vcr", "~> 6.0.0"

  # https://github.com/bblimke/webmock
  spec.add_development_dependency "webmock", "3.9.3"

  # https://github.com/bundler/bundler
  spec.add_runtime_dependency "bundler", "~> 2.1.4"

  # https://github.com/jimweirich/rake
  spec.add_runtime_dependency "rake"

  # https://github.com/rubygems/gems
  spec.add_runtime_dependency 'gems', '~> 1.2.0'

  # https://github.com/peter-murach/github
  spec.add_runtime_dependency 'github_api', '~> 0.19.0'

end
