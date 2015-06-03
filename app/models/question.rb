class Question < ActiveRecord::Base

	belongs_to :survey_section, dependent: :destroy
	belongs_to :option_group, foreign_key: "group_id"
	has_many :question_options
	has_many :option_choices, through: :question_options
	has_many :answers, through: :option_choices

	validates :survey_section_id, presence: true
	validates :subtext, presence: true

	accepts_nested_attributes_for :option_choices

end
