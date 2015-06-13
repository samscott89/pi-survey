class Survey < ActiveRecord::Base
	include NotDeleteable

	validates :name, presence: true
	has_many :sections, class_name: "SurveySection"
	belongs_to :owner, class_name: "User"
end
