class Tag < ActiveRecord::Base
	validates :name, presence: true
	has_many :survey_tags, dependent: :destroy
	has_many :surveys, through: :survey_tags
end
