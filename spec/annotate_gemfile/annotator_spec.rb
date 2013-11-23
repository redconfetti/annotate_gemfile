require 'spec_helper'

describe AnnotateGemfile::Annotator do
  subject             { AnnotateGemfile::Annotator.new('/home/myproj/app/Gemfile') }
  its(:some_property) { should eq nil }
  
  describe "#bundler_details" do
    it "should output stuff" do
      result = subject.bundler_details
      expect(result).to eq "rails (= 4.0.0)"
    end
  end
end
