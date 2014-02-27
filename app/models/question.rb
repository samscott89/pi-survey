class Question < ActiveRecord::Base

	belongs_to :survey_section, dependent: :destroy

	validates :survey_section_id, presence: true

end
