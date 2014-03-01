require 'spec_helper'

describe QuestionOption do
  let(:survey) {FactoryGirl.create(:survey)}
  let(:section) {FactoryGirl.create(:survey_section, survey_id: survey.id)}
  let(:question) {FactoryGirl.create(:question, survey_section_id: section.id)}

  let(:type) { FactoryGirl.create(:question_type) }
  let(:group) { FactoryGirl.create(:option_group, question_type: type) }
  let(:choice) { FactoryGirl.create(:option_choice, option_group: group) }

  let(:question_option) { question.question_options.build(option_choice_id: choice.id) }

  subject { question_option }

  it { should be_valid }

  describe "question_option methods" do
    it { should respond_to(:question) }
    it { should respond_to(:option_choice) }
    its(:question) { should eq question }
    its(:option_choice) { should eq choice }
  end

end
