class Question < ActiveRecord::Base
	include NotDeleteable
	
	belongs_to :survey_section
	has_one :option_group

	has_one :question_type, through: :option_group
	has_many :option_choices, through: :option_group

	#has_many :question_options, dependent: :destroy
	has_many :answers

	validates_presence_of :survey_section_id
	validates_presence_of :subtext

	accepts_nested_attributes_for :option_choices
end
