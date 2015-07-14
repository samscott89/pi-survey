/
  OptionGroup is mostly used as a way to group certain question possibilities together.

  It has an inhernt type, given by question_type. Therefore each child member (option_choices) all have the same type.

  It has a number of option_choices

/
class OptionGroup < ActiveRecord::Base
	has_many :option_choices, inverse_of: :option_group
	belongs_to :question, inverse_of: :option_group
	belongs_to :question_type, foreign_key: "type_id"

	accepts_nested_attributes_for :option_choices, allow_destroy: true, 
	reject_if: proc { |attributes| attributes['choice_name'].blank? }
	
	validates :type_id, presence: true

	/ Returns a copy of the OptionGroup
	  with all new Optionchoices. (Not saved).
	/
	def deep_copy
		new_og = self.dup
		self.option_choices.each do |oc|
			new_og.option_choices.build(choice_name: oc.choice_name)
		end

		new_og
	end
end
