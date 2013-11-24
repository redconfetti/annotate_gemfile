require 'spec_helper'

describe AnnotateGemfile::Parser do
  subject         { AnnotateGemfile::Parser.new(File.dirname(__FILE__) + "/../dummy/Gemfile") }

  # its(:class)   { should have_constant(:MAJOR, Fixnum) }
  
  # before(:each)   { IO.should_receive(:read).and_return("File Contents") }

  it "raises exception if gemfile specified does not exist" do
    expect { AnnotateGemfile::Parser.new('/bogus/file/path') }.to raise_error(IOError, "Gemfile not found at /bogus/file/path")
  end

  it "loads gemfile contents" do
    parser = AnnotateGemfile::Parser.new(File.dirname(__FILE__) + "/../dummy/Gemfile_empty")
    contents = parser.instance_eval{ @gemfile_contents }
    expect(contents).to eq "source 'https://rubygems.org'"
  end

  describe "#datetime_string" do
    it "returns UTC date/time string formatted for use in filename" do
      fake_current_time = Time.at(1385232600).utc
      Time.should_receive(:now).and_return(fake_current_time)
      expect(subject.class.datetime_string).to eq "11-23-13-18_50_00"
    end
  end

  describe "#remove_commented_lines" do
    it "removes commented lines from loaded gemfile_source" do
      subject.instance_eval { @gemfile_contents = "line 1\nline 2\n#line 3\nline 4\n" }
      subject.remove_commented_lines
      expect(subject.instance_eval { @gemfile_contents }).to eq "line 1\nline 2\nline 4\n"
    end

    it "removes commented lines beginning with spaces or tabs from loaded gemfile_source" do
      subject.instance_eval { @gemfile_contents = "#line 1\nline 2\n  #line 3\n   # line 4\nline 5\nline 6" }
      subject.remove_commented_lines
      expect(subject.instance_eval { @gemfile_contents }).to eq "line 2\nline 5\nline 6"
    end
  end
end