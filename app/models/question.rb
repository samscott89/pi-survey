class Question < ActiveRecord::Base
	include NotDeleteable
	
	belongs_to :survey_section
	belongs_to :question_type
	has_one :option_group

	has_many :question_options, dependent: :destroy
	has_many :option_choices
	has_many :answers

	validates :survey_section_id, presence: true
	validates :subtext, presence: true

	accepts_nested_attributes_for :option_choices
end
