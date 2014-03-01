require 'spec_helper'

describe UnitOfMeasurement do
	let(:unit) {UnitOfMeasurement.create(name: "m")}

	subject { unit }
	it { should respond_to(:name) }
	it { should be_valid}
end