require 'spec_helper'

describe Survey do
	let(:survey) {FactoryGirl.create(:survey)}

	subject {survey}
	it { should respond_to(:name) }
	it { should respond_to(:instructions) }

	it { should respond_to(:tags) }
	it { should respond_to(:sections)}

	describe "when name is not present" do
      before { survey.name = " " }
      it { should_not be_valid }
    end
end
