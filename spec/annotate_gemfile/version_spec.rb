require 'spec_helper'

describe AnnotateGemfile::Version do

  its(:class) { should have_constant(:MAJOR, Fixnum) }
  its(:class) { should have_constant(:MINOR, Fixnum) }
  its(:class) { should have_constant(:PATCH, Fixnum) }
  its(:class) { should have_constant(:BUILD, NilClass) }
  its(:class) { should have_constant(:STRING, String) }

end