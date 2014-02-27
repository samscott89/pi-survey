require 'spec_helper'

describe SurveySection do
	let(:survey) {FactoryGirl.create(:survey)}
	let(:survey_section) {FactoryGirl.create(:survey_section, survey_id: survey.id)}


	subject {survey_section}
	it { should respond_to(:name) }
	it { should respond_to(:title) }
	it { should respond_to(:subtitle) }
	it { should respond_to(:required) }

	it { should respond_to(:survey) }
	it { should respond_to(:questions) }

	it { should be_valid }

	describe "when name is not present" do
      before { survey_section.name = " " }
      it { should_not be_valid }
    end
end
