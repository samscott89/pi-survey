class Answer < ActiveRecord::Base
	include NotDeleteable

	has_many :answer_options, dependent: :destroy, inverse_of: :answer

	belongs_to :user
#	belongs_to :unit, class_name:"UnitOfMeasurement"
	belongs_to :question

	validates :user_id, presence: true
	validates :question_id, presence: true

	validate :check_answers

	before_validation :clean_up

	# This enables mass assignment of answer_options to a single answer
	# However, if the answer_option has no option_id it is ignored.
	# Furthermore, if it is a new answer_option and the option_id is 0, then ignore.
	accepts_nested_attributes_for :answer_options,
		allow_destroy: true

    def check_answers
    	if !self.question.nil? and self.question.required? and 
    		self.answer_text.blank? and
    		self.answer_options.to_a.count {|ao| !ao.marked_for_destruction?} == 0
    		errors.add(:question, "is required")
    	end
    end

    def clean_up
    	# If answer_text has been set for some reason
    	if !self.has_other or !self.question.allow_other
    		self.answer_text = nil
    	end
    end
end
