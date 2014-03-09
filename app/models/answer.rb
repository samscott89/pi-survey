class Answer < ActiveRecord::Base
	belongs_to :question_option, foreign_key: "option_id"
	belongs_to :user
	belongs_to :unit, class_name:"UnitOfMeasurement"

	validates :user_id, presence: true
	validates :option_id, presence: true
	validate :check_answers

	# This allows for multiple options answered simultaneously (e.g. for checkboxes)
	accepts_nested_attributes_for :question_option


	# before_save :check_answers

	# Saves only when at least one value is not blank
	def check_answers
		answer_valid = false
		[:answer_numeric, :answer_text, :answer_boolean].each do |a|
			answer_valid = true unless self[a].blank?
		end

		errors.add(:answer_text, "At least one answer value must not be blank") unless answer_valid
	end
end
