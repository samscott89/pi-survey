/
  This is basically just a reference table between questions and option_choices.

  These are actually also going to constitute the pool which users pick answers from.
  However, this model doesn't need to be aware of that.
/
class QuestionOption < ActiveRecord::Base
	belongs_to :question
	belongs_to :option_choice

	has_many :answer_options

	validates :question_id, presence: true
	validates :option_choice_id, presence: true
end
