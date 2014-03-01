require 'spec_helper'

describe Answer do
  let(:survey) {FactoryGirl.create(:survey)}
  let(:section) {FactoryGirl.create(:survey_section, survey_id: survey.id)}
  let(:question) {FactoryGirl.create(:question, survey_section_id: section.id)}

  let(:type) { FactoryGirl.create(:question_type) }
  let(:group) { FactoryGirl.create(:option_group, question_type: type) }
  let(:choice) { FactoryGirl.create(:option_choice, option_group: group) }

  let(:question_option) { question.question_options.build(option_choice_id: choice.id) }

  let(:answer) { FactoryGirl.create(:answer)}

  subject { answer} 

  it { should respond_to(:user) }
  it { should respond_to(:question_option) }

  it { should respond_to(:answer_text)}
  it { should respond_to(:answer_numeric)}
  it { should respond_to(:answer_boolean)}

  it { should respond_to(:unit)}

  it { should be_valid }


  # Tests missing: answer not missing, answer matches correct type
  # Answer value equal to option choice data when applicable
  describe "when answer value is not present" do
    before do
      answer.answer_text = " "
      answer.answer_numeric = nil
      answer.answer_boolean = nil
    end
    it { should_not be_valid}
  end
  
end
