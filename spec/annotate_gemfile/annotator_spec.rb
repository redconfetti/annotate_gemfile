require 'spec_helper'

describe AnnotateGemfile::Annotator do
  subject               { AnnotateGemfile::Annotator.new(gemfile_path) }
  let(:gemfile_path)    { File.dirname(__FILE__) + "/../dummy/Gemfile" }

  describe ".datetime_string" do
    it "returns UTC date/time string formatted for use in filename" do
      fake_current_time = Time.at(1385232600).utc
      Time.should_receive(:now).and_return(fake_current_time)
      expect(subject.class.datetime_string).to eq "11-23-13-18_50_00"
    end
  end

  describe ".github_repo" do
    it "returns repository information for gem" do
      VCR.use_cassette('github.com/api/get/rails') do
        result = subject.class.github_repo('rails', 'rails')
        expect(result).to be_an_instance_of Hash
        expect(result[:id]).to eq 8514
        expect(result[:name]).to eq "rails"
        expect(result[:description]).to eq "Ruby on Rails"
        expect(result[:created_at]).to eq "2008-04-11T02:19:47Z"
        expect(result[:updated_at]).to eq "2013-11-25T06:35:03Z"
        expect(result[:pushed_at]).to eq "2013-11-24T23:43:06Z"
        expect(result[:full_name]).to eq "rails/rails"
        expect(result[:html_url]).to eq "https://github.com/rails/rails"
        expect(result[:homepage]).to eq "http://rubyonrails.org"
        expect(result[:ssh_url]).to eq "git@github.com:rails/rails.git"
        expect(result[:clone_url]).to eq "https://github.com/rails/rails.git"
        expect(result[:git_url]).to eq "git://github.com/rails/rails.git"
        expect(result[:svn_url]).to eq "https://github.com/rails/rails"
      end
    end
  end

  describe "#backup_gemfile" do
    let(:backup_file_path) { gemfile_path + "-backup-11-23-13-18_50_00" }
    before do
      AnnotateGemfile::Annotator.should_receive(:datetime_string).and_return("11-23-13-18_50_00")
    end

    after do
      if File.exist? backup_file_path
        FileUtils.rm backup_file_path
      end
    end

    it "returns path of backup Gemfile" do
      result = subject.backup_gemfile
      expect(result).to eq backup_file_path
    end

    it "creates a backup of Gemfile being processed" do
      backup_file_path = subject.backup_gemfile
      expect { File.exist?(backup_file_path) }.to be_true
    end
  end
end
