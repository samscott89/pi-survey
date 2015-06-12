/
This is basically a parallel of QestionOption:
This helps connect a single answer or response to a multitude of answers.
/
class AnswerOption < ActiveRecord::Base
	belongs_to :answer
	belongs_to :question_option, foreign_key: "option_id"
	
	before_validation :clean_up

	validates :option_id, presence: true

	def clean_up
		# Marks the AnswerOption for destruction if option id is 0 (this catches unset checkboxes)
		if self.option_id == 0
			puts "Up for destruction: #{self}"
			self.mark_for_destruction
		end

		# Adds answer text if missing based on the corresponding OptionChoice
		if (self.answer_text.nil? or self.option_id_changed?) and self.option_id != 0
			self.answer_text = self.question_option.option_choice.choice_name.capitalize
		end

	end
			
end
