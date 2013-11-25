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

  describe ".is_gem_definition?" do
    it "returns true if line begins with gem call" do
      expect(AnnotateGemfile::Parser.is_gem_definition?("    gem \"my-fancy_gem23\"")).to be_true
      expect(AnnotateGemfile::Parser.is_gem_definition?("    gem \"abebooks4r\"")).to be_true
    end

    it "returns false if line does not begin with gem call " do
      expect(AnnotateGemfile::Parser.is_gem_definition?(" gem \"invalid\^\!gem\*name\"")).to be_false
      expect(AnnotateGemfile::Parser.is_gem_definition?(" notgem \"sinatra\"")).to be_false
      expect(AnnotateGemfile::Parser.is_gem_definition?(" ilike \"sinatra\"")).to be_false 
    end
  end

  describe ".extract_gemname" do
    it "raises exception if argument does not contain gem definition" do
      expect { AnnotateGemfile::Parser.extract_gemname('lala') }.to raise_error(ArgumentError, "Argument string does not contain gem definition")
    end

    it "returns gem name from gem definition line string" do
      expect(AnnotateGemfile::Parser.extract_gemname('     gem "sinatra"')).to eq "sinatra"
      expect(AnnotateGemfile::Parser.extract_gemname(' gem "some-gem_name"')).to eq "some-gem_name"
    end
  end

  describe ".datetime_string" do
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

  describe "#load_gemfile_array" do
    it "raises exception if gemfile string not present" do
      subject.instance_eval { @gemfile_contents = nil }
      expect { subject.load_gemfile_array }.to raise_error(RuntimeError, "Gemfile contents not present")
    end

    it "converts gemfile contents into gemfile array" do
      subject.remove_commented_lines
      subject.load_gemfile_array
      gemfile_array = subject.instance_eval { @gemfile_array }
      expect(gemfile_array[0]).to eq "source 'https://rubygems.org'\n"
      expect(gemfile_array[1]).to eq "ruby '2.0.0'\n"
    end
  end
  
  describe "#load_dependencies" do
    it "loads gem dependency array" do
      subject.load_dependencies
      dependencies = subject.instance_eval { @gem_dependencies }
      expect(dependencies).to be_an_instance_of Array
      dependencies.each do |dependency|
        expect(dependency).to be_an_instance_of Bundler::Dependency
      end
      # puts dependencies.inspect
    end
  end

  describe "#find_dependency" do
    before { subject.load_dependencies }
    it "raises exception of gem dependencies are not present" do
      subject.instance_eval { @gem_dependencies = [] }
      expect { subject.find_dependency('sinatra') }.to raise_error(RuntimeError, "Gem dependencies not present")
    end

    it "returns nil when gem is not present" do
      result = subject.find_dependency('rails')
      expect(result).to eq nil
    end

    it "returns dependency object when gem is present" do
      result = subject.find_dependency('yard')
      expect(result).to be_an_instance_of Bundler::Dependency
      expect(result.name).to eq 'yard'
    end
  end

  describe "#build_meta_array" do
    it "raises exception if gemfile array is empty" do
      subject.instance_eval { @gemfile_array = [] }
      expect { subject.build_meta_array }.to raise_error(RuntimeError, "Gemfile lines not loaded")
    end

    it "creates gemfile metadata array" do
      subject.remove_commented_lines
      subject.load_gemfile_array
      subject.load_dependencies
      subject.build_meta_array
      gemfile_meta = subject.instance_eval { @gemfile_meta }
      expect(gemfile_meta).to be_an_instance_of Array
      expect(gemfile_meta[0]).to be_an_instance_of Hash
      expect(gemfile_meta[0][:line]).to eq 2
      expect(gemfile_meta[0][:name]).to eq "sinatra"
    end
  end

end