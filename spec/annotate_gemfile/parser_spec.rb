require 'spec_helper'

describe AnnotateGemfile::Parser do
  subject         { AnnotateGemfile::Parser.new('/home/myproj/app/Gemfile') }

  # its(:class)   { should have_constant(:MAJOR, Fixnum) }
  its(:gemfile_source)   { should be_an_instance_of String }
  
  before(:each)   { IO.should_receive(:read).and_return("File Contents") }
end