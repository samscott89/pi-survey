class SurveyTag < ActiveRecord::Base
	belongs_to :tag
	belongs_to :survey
	validates :survey_id, presence: true
	validates :tag_id, presence: true
end
