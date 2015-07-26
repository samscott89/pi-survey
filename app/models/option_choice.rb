/
	An OptionChoice defines the possible response to a question. This is given in the column name (probably poorly chosen)

	Each OptionChoice belongs to an option_group by definition.

	Note: Questions are linked to OptionChoices via QuestionOptions. This is so that the data which option choice stores 
	(in name) can be reused by reference.

/
class OptionChoice < ActiveRecord::Base
	# has_many :questions, through: :question_options
	belongs_to :option_group, inverse_of: :option_choices
	
	validates_presence_of :option_group
	validates :choice_name, presence: true
end
