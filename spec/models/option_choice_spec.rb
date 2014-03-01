require 'spec_helper'

describe OptionChoice do
	let(:type) { FactoryGirl.create(:question_type) }
	let(:group) { FactoryGirl.create(:option_group, question_type: type) }
	let(:choice) { FactoryGirl.create(:option_choice, option_group: group) }
	subject { choice } 

	it { should respond_to(:choice_name) }
	it { should respond_to(:option_group) }

	# it { should respond_to(:questions) }

	it { should be_valid}

	describe "when group is not present" do
		before {choice.option_group_id = nil}
		it { should_not be_valid}
	end
end
