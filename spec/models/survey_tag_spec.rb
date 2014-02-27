require 'spec_helper'

describe SurveyTag do
  let(:survey) { FactoryGirl.create(:survey) }
  let(:tag) { FactoryGirl.create(:tag) }
  let(:survey_tag) { survey.survey_tags.build(tag_id: tag.id) }

  subject { survey_tag }

  it { should be_valid }

  describe "survey_tag methods" do
    it { should respond_to(:survey) }
    it { should respond_to(:tag) }
    its(:survey) { should eq survey }
    its(:tag) { should eq tag }
  end
end
