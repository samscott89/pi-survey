class Question < ActiveRecord::Base
	acts_as_paranoid
	
	has_many :charts
	belongs_to :survey_section
	has_one :option_group, inverse_of: :question

	has_one :question_type, through: :option_group
	has_many :option_choices, through: :option_group

	#has_many :question_options, dependent: :destroy
	has_many :answers

	validates_presence_of :survey_section_id
	validates_presence_of :subtext

	has_one :survey, through: :survey_section

	accepts_nested_attributes_for :option_group
end
