/
  OptionGroup is mostly used as a way to group certain question possibilities together.

  It has an inhernt type, given by question_type. Therefore each child member (option_choices) all have the same type.

  It has a number of option_choices

/
class OptionGroup < ActiveRecord::Base
	has_many :option_choices, dependent: :destroy
	belongs_to :question_type, foreign_key: "type_id"

	has_many :option_choices
	
	validates :type_id, presence: true
end
