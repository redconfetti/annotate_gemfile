require 'spec_helper'
require 'annotate_gemfile/version'

describe AnnotateGemfile::VERSION do

  it { should have_constant(:MAJOR, Fixnum) }
  it { should have_constant(:MINOR, Fixnum) }
  it { should have_constant(:PATCH, Fixnum) }
  it { should have_constant(:BUILD, NilClass) }
  it { should have_constant(:STRING, String) }

end