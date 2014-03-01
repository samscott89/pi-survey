require 'spec_helper'

describe Question do
	let(:survey) {FactoryGirl.create(:survey)}
	let(:section) {FactoryGirl.create(:survey_section, survey_id: survey.id)}
	let(:question) {FactoryGirl.create(:question, survey_section_id: section.id)}

	subject {question}
	it { should respond_to(:name) }
	it { should respond_to(:subtext) }
	it { should respond_to(:required) }
	it { should respond_to(:survey_section)}

	it { should respond_to(:option_group)}
	it { should respond_to(:option_choices)}

	it { should be_valid}


  # Tests missing: validate that all options with the same question have the same group
  # question.group == question.option_choices.group
  
end
