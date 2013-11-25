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
end
