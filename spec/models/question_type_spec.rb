require 'spec_helper'

describe QuestionType do
	let(:type) { FactoryGirl.create(:question_type) }

	subject { type } 

	it { should respond_to(:name) }
	it { should respond_to(:option_groups)}

	it { should be_valid}

	describe "when name is not present" do
		before {type.name = " "}
		it { should_not be_valid}
	end

end
