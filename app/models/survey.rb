class Survey < ActiveRecord::Base
	validates :name, presence: true
	has_many :survey_tags, dependent: :destroy
	has_many :tags, through: :survey_tags
	has_many :sections, class_name: "SurveySection", dependent: :destroy
end
