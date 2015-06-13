/
  OptionGroup is mostly used as a way to group certain question possibilities together.

  It has an inhernt type, given by question_type. Therefore each child member (option_choices) all have the same type.

  It has a number of option_choices

/
class OptionGroup < ActiveRecord::Base
	has_many :option_choices
	belongs_to :question_type, foreign_key: "type_id"
	
	validates :type_id, presence: true

	@@multiple_types = [1,2,5,6]

	/
	Helper function to determine if OptionGroup expects multiple responses
	/
	def multiple?
		@@multiple_types.include? self.type_id
	end 

	def self.multiples
		OptionGroup.where(type_id: @@multiple_types).ids
	end
end
