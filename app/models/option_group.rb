class OptionGroup < ActiveRecord::Base
	has_one :type, class_name: "QuestionType"
	has_and_belongs_to_many :questions

	validates :type_id, presence: true
end
