require 'spec_helper'

describe AnnotateGemfile::Parser do

  subject               { AnnotateGemfile::Parser.new(gemfile_path) }
  let(:gemfile_path)    { File.dirname(__FILE__) + "/../dummy/Gemfile" }
  its(:gemfile_meta)    { should == [] }
  its(:gemfile_array)   { should == [] }

  describe ".parse" do
    it "returns processed parser" do
      parser = AnnotateGemfile::Parser.parse(gemfile_path)
      expect(parser).to be_an_instance_of AnnotateGemfile::Parser
      gemfile_array = parser.gemfile_array
      gemfile_meta = parser.gemfile_meta
      expect(gemfile_array).to be_an_instance_of Array
      # gemfile_array.each_with_index {|line,index| puts "#{index}: #{line}" }
      # gemfile_meta.each_with_index {|line,index| puts "#{index}: #{line}" }
      expect(gemfile_array[0]).to eq "source 'https://rubygems.org'\n"
      expect(gemfile_array[1]).to eq "ruby '2.0.0'\n"
      expect(gemfile_array[2]).to eq "gem 'sinatra'\n"
      expect(gemfile_array[3]).to eq "gem 'thin'\n"
      expect(gemfile_array[4]).to eq "gem 'rspec', :require => 'spec'\n"
      expect(gemfile_array[5]).to eq "gem 'json'\n"
      expect(gemfile_array[6]).to eq "\n"
      expect(gemfile_array[7]).to eq "gem 'nokogiri', :git => 'git://github.com/tenderlove/nokogiri.git', :tag => 'v1.6.0'\n"
      expect(gemfile_array[8]).to eq "\n"
      expect(gemfile_array[9]).to eq "group :development do\n"
      expect(gemfile_array[10]).to eq "  gem \"lunchy\", :git => 'git://github.com:mperham/lunchy.git', :branch => 'master'\n"
      expect(gemfile_array[11]).to eq "end\n"
      expect(gemfile_array[12]).to eq "\n"
      expect(gemfile_array[13]).to eq "group :doc do\n"
      expect(gemfile_array[14]).to eq "  gem \"yard\", \"~> 0.8.7\"\n"
      expect(gemfile_array[15]).to eq "end\n"
      expect(gemfile_array[16]).to eq "\n"
      expect(gemfile_array[17]).to eq "gem \"figaro\"\n"
      expect(gemfile_array[18]).to eq "gem \"capybara\", group: [:development, :test]\n"
      expect(gemfile_array[19]).to eq "\n"
      expect(gemfile_array[20]).to eq "gem \"annotate_gemfile\", :path => '../../annotate_gemfile'\n"
      expect(gemfile_meta).to be_an_instance_of Array
      expect(gemfile_meta[0][:line_number]).to eq 2
      expect(gemfile_meta[0][:name]).to eq "sinatra"
      expect(gemfile_meta[1][:line_number]).to eq 3
      expect(gemfile_meta[1][:name]).to eq "thin"
      expect(gemfile_meta[2][:line_number]).to eq 4
      expect(gemfile_meta[2][:name]).to eq "rspec"
      expect(gemfile_meta[3][:line_number]).to eq 5
      expect(gemfile_meta[3][:name]).to eq "json"
      expect(gemfile_meta[4][:line_number]).to eq 7
      expect(gemfile_meta[4][:name]).to eq "nokogiri"
      expect(gemfile_meta[4][:source]).to be_an_instance_of Bundler::Source::Git
      expect(gemfile_meta[4][:source].uri).to eq "git://github.com/tenderlove/nokogiri.git"
      expect(gemfile_meta[4][:source].ref).to eq "v1.6.0"
      expect(gemfile_meta[5][:line_number]).to eq 10
      expect(gemfile_meta[5][:name]).to eq "lunchy"
      expect(gemfile_meta[5][:source]).to be_an_instance_of Bundler::Source::Git
      expect(gemfile_meta[5][:source].uri).to eq "git://github.com:mperham/lunchy.git"
      expect(gemfile_meta[5][:source].branch).to eq "master"
      expect(gemfile_meta[6][:line_number]).to eq 14
      expect(gemfile_meta[6][:name]).to eq "yard"
      expect(gemfile_meta[7][:line_number]).to eq 17
      expect(gemfile_meta[7][:name]).to eq "figaro"
      expect(gemfile_meta[8][:line_number]).to eq 18
      expect(gemfile_meta[8][:name]).to eq "capybara"
      expect(gemfile_meta[9][:line_number]).to eq 20
      expect(gemfile_meta[9][:name]).to eq "annotate_gemfile"
      expect(gemfile_meta[9][:source]).to be_an_instance_of Bundler::Source::Path
      expect(gemfile_meta[9][:source].path).to be_an_instance_of Pathname
      expect(gemfile_meta[9][:source].path.to_s).to eq "../../annotate_gemfile"
    end
  end

  describe ".new" do
    it "raises exception if gemfile specified does not exist" do
      expect { AnnotateGemfile::Parser.new('/bogus/file/path') }.to raise_error(IOError, "Gemfile not found at /bogus/file/path")
    end

    it "loads gemfile contents" do
      parser = AnnotateGemfile::Parser.new(File.dirname(__FILE__) + "/../dummy/Gemfile_empty")
      contents = parser.instance_eval{ @gemfile_contents }
      expect(contents).to eq "source 'https://rubygems.org'"
    end
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
      expect(gemfile_meta[4]).to be_an_instance_of Hash
      expect(gemfile_meta[4][:line_number]).to eq 7
      expect(gemfile_meta[4][:name]).to eq "nokogiri"
      expect(gemfile_meta[4][:type]).to eq :runtime
      expect(gemfile_meta[4][:source]).to be_an_instance_of Bundler::Source::Git
      expect(gemfile_meta[4][:source]).to be_an_instance_of Bundler::Source::Git
      expect(gemfile_meta[4][:source].uri).to eq "git://github.com/tenderlove/nokogiri.git"
      expect(gemfile_meta[4][:source].ref).to eq "v1.6.0"
      expect(gemfile_meta[4][:platforms]).to eq []
      expect(gemfile_meta[4][:requirement]).to be_an_instance_of Gem::Requirement
      expect(gemfile_meta[5][:line_number]).to eq 10
      expect(gemfile_meta[5][:name]).to eq "lunchy"
      expect(gemfile_meta[5][:source]).to be_an_instance_of Bundler::Source::Git
      expect(gemfile_meta[5][:source].uri).to eq "git://github.com:mperham/lunchy.git"
      expect(gemfile_meta[5][:source].branch).to eq "master"
      expect(gemfile_meta[9][:name]).to eq "annotate_gemfile"
      expect(gemfile_meta[9][:source]).to be_an_instance_of Bundler::Source::Path
      expect(gemfile_meta[9][:source].path).to be_an_instance_of Pathname
      expect(gemfile_meta[9][:source].path.to_s).to eq "../../annotate_gemfile"
    end
  end

end