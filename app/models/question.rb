class Question < ActiveRecord::Base

	belongs_to :survey_section
	belongs_to :option_group, foreign_key: "group_id"
	
	has_one :blank, class_name: "QuestionBlank"

	has_many :question_options
	has_many :option_choices, through: :question_options
	has_many :answers, through: :option_choices

	validates :survey_section_id, presence: true
	validates :subtext, presence: true

	accepts_nested_attributes_for :option_choices

	after_create :add_blank

	def add_blank
		if self.required?
			#TODO: user-chosen values for unspecified.
			QuestionBlank.create(question: self, value: "Unspecified") 
		end
	end
end
