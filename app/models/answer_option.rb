/
This is basically a parallel of QestionOption:
This helps connect a single answer or response to a multitude of answers.
/
class AnswerOption < ActiveRecord::Base
	belongs_to :answer, inverse_of: :answer_options
  	validates_presence_of :answer

	belongs_to :option_choice, foreign_key: "option_id"
	
	before_validation :clean_up
	before_save :remove_duplicates

	validates :option_id, presence: true

	def remove_duplicates
		AnswerOption.where(answer_id: self.answer_id, option_id: self.option_id).where.not(updated_at: nil).destroy_all
	end

	def clean_up
		# Adds answer text if missing based on the corresponding OptionChoice
		if (self.answer_text.nil? or (self.option_id_changed? and !self.option_id_was.nil?)) and self.option_id != 0
			self.answer_text = self.option_choice.choice_name.capitalize
		end

		# Marks the AnswerOption for destruction if option id is 0 (this catches unset checkboxes)
		# OR answer is blank (not set by previous code) (needed for validation).
		if self.option_id == 0 or self.answer_text.blank?
			#puts "Up for destruction: #{self}"
			self.mark_for_destruction
		end
	end
			
end
