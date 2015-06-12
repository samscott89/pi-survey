class Answer < ActiveRecord::Base
	has_many :answer_options, dependent: :destroy

	belongs_to :user
	belongs_to :unit, class_name:"UnitOfMeasurement"
	belongs_to :question

	validates :user_id, presence: true
	validate :check_answers

	accepts_nested_attributes_for :answer_options, reject_if: proc { |attributes| attributes['option_id'].nil? }


	# before_save :check_answers

	# Saves only when at least one value is not blank
	def check_answers
		if self.question.required?
			answer_valid = false
			[:answer_numeric, :answer_text, :answer_boolean].each do |a|
				answer_valid = true unless self[a].blank?
			end
		else
			answer_valid = true
		end

		errors.add(:answer_text, "At least one answer value must not be blank") unless answer_valid
	end
end
