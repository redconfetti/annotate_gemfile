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

  describe "#remove_commented_lines" do
    it "removes commented lines from loaded gemfile_source" do
      subject.instance_eval { @gemfile_source = "line 1\nline 2\n#line 3\nline 4\n" }
      subject.remove_commented_lines
      expect(subject.gemfile_source).to eq "line 1\nline 2\nline 4\n"
    end

    it "removes commented lines beginning with spaces or tabs from loaded gemfile_source" do
      subject.instance_eval { @gemfile_source = "#line 1\nline 2\n  #line 3\n   # line 4\nline 5\nline 6" }
      subject.remove_commented_lines
      expect(subject.gemfile_source).to eq "line 2\nline 5\nline 6"
    end
  end
end