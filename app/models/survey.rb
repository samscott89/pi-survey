class Survey < ActiveRecord::Base
	include NotDeleteable

	validates :name, presence: true
	has_many :sections, class_name: "SurveySection", dependent: :destroy, inverse_of: :survey
	has_many :survey_sections
	belongs_to :owner, class_name: "User"
end
