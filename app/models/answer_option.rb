/
This is basically a parallel of QestionOption:
This helps connect a single answer or response to a multitude of answers.
/
class AnswerOption < ActiveRecord::Base
	belongs_to :answer
	belongs_to :question_option, foreign_key: "option_id"
	
	# This will add an answer text where none has been specified.
	before_validation :add_answer_text

	validates :option_id, presence: true

	def add_answer_text
		puts "Starting validation"
		if self.answer_text.nil? and !self.option_id.nil?
			self.answer_text = self.question_option.option_choice.choice_name.capitalize
		end
	end
			
end
