class Chart < ActiveRecord::Base
	has_many :chart_types
	has_many :questions
	belongs_to :survey
	belongs_to :owner, class_name: "User"
end
