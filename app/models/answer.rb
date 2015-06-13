class Answer < ActiveRecord::Base
	include NotDeleteable

	has_many :answer_options, dependent: :destroy, inverse_of: :answer

	belongs_to :user
#	belongs_to :unit, class_name:"UnitOfMeasurement"
	belongs_to :question

	validates :user_id, presence: true
	validates :question_id, presence: true

	validate :check_answers

	# This enables mass assignment of answer_options to a single answer
	# However, if the answer_option has no option_id it is ignored.
	# Furthermore, if it is a new answer_option and the option_id is 0, then ignore.
	accepts_nested_attributes_for :answer_options,
		allow_destroy: true,
		reject_if: proc { |attributes| attributes['option_id'].nil? or 
									  (attributes['option_id'] == 0 and attributes['id'].nil?) }


	# Saves only when at least one value is not blank
	def check_answers
		answer_valid = !(self.question.required? and self.answer_options.empty?)
		errors.add(self, "At least one answer value must not be blank") unless answer_valid
	end
end
