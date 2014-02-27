require 'spec_helper'

describe Question do
	let(:survey) {FactoryGirl.create(:survey)}
	let(:section) {FactoryGirl.create(:survey_section, survey_id: survey.id)}
	let(:question) {FactoryGirl.create(:question, survey_section_id: section.id)}

	subject {question}
	it { should respond_to(:name) }
	it { should respond_to(:subtext) }
	it { should respond_to(:required) }
	it { should respond_to(:group_id) }
	it { should respond_to(:survey_section)}

	it { should be_valid}

	describe "when section is not present" do
      before { question.survey_section_id = nil }
      it { should_not be_valid }
    end

	describe "survey_tag methods" do
	    it { should respond_to(:survey_section) }
	    its(:survey_section) { should eq section }
	end
end
