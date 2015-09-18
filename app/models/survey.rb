class Survey < ActiveRecord::Base
	acts_as_paranoid
	
	validates :name, presence: true
	has_many :sections, class_name: "SurveySection", dependent: :destroy, inverse_of: :survey
	has_many :survey_sections
	has_many :charts
	has_many :active_surveys, dependent: :destroy, inverse_of: :survey

	belongs_to :owner, class_name: "User"
	has_many :questions, through: :sections
end
