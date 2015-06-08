class SurveySection < ActiveRecord::Base
	validates :name, presence: true
	validates :title, presence: true
	# validates :required, presence: true

	belongs_to :survey
	has_many :questions
end
