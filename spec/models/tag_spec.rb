require 'spec_helper'

describe Tag do
	let(:tag) {FactoryGirl.create(:tag)}

	subject {tag}

	it { should respond_to(:name)}
	it { should respond_to(:surveys)}

	it { should be_valid }

	describe "when name is not present" do
      before { tag.name = " " }
      it { should_not be_valid }
    end
end
