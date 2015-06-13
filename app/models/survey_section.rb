class SurveySection < ActiveRecord::Base
	include NotDeleteable
	
	validates :name, presence: true
	validates :title, presence: true
	# validates :required, presence: true

	belongs_to :survey
	has_many :questions
end
