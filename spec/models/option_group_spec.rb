require 'spec_helper'

describe OptionGroup do
	let(:type) { FactoryGirl.create(:question_type) }
	let(:group) { FactoryGirl.create(:option_group, question_type: type) }

	subject { group } 

	it { should respond_to(:name) }
	it { should respond_to(:question_type) }

	# it { should respond_to(:questions) }

	it { should be_valid}

	describe "when type is not present" do
		before {group.type_id = nil}
		it { should_not be_valid}
	end
end
