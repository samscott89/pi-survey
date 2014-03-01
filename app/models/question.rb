class Question < ActiveRecord::Base

	belongs_to :survey_section, dependent: :destroy
	belongs_to :option_group, foreign_key: "group_id" #This isn¡t strictly necessary, but might make things easier later.
	has_many :question_options
	has_many :option_choices, through: :question_options

	validates :survey_section_id, presence: true

end
