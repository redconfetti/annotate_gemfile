require 'spec_helper'

describe AnnotateGemfile::Parser do
  subject         { AnnotateGemfile::Parser.new('/home/myproj/app/Gemfile') }

  # its(:class)   { should have_constant(:MAJOR, Fixnum) }
  its(:gemfile_source)   { should be_an_instance_of String }
  
  before(:each)   { IO.should_receive(:read).and_return("File Contents") }

  describe "#datetime_string" do
    it "returns UTC date/time string formatted for use in filename" do
      fake_current_time = Time.at(1385232600).utc
      Time.should_receive(:now).and_return(fake_current_time)
      expect(subject.class.datetime_string).to eq "11-23-13-18_50_00"
    end
  end
end