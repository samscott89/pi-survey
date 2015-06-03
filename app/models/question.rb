class Question < ActiveRecord::Base

	belongs_to :survey_section, dependent: :destroy
	belongs_to :option_group, foreign_key: "group_id"
	has_many :question_options
	has_many :option_choices, through: :question_options
	has_many :answers, through: :option_choices

	validates :survey_section_id, presence: true
	validates :subtext, presence: true

	accepts_nested_attributes_for :option_choices

	after_create :add_blank

	def add_blank
		qid = self.option_group.question_type.id
		if [1,2].include? qid  # multiple choice type
			self.question_options.create(option_choice_id: (51 + qid*3)) # Blank answers for these questions
		end
	end
end
