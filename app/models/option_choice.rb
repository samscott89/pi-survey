/
	An OptionChoice defines the possible response to a question. This is given in the column name (probably poorly chosen)

	Each OptionChoice belongs to an option_group by definition.

	Note: Questions are linked to OptionChoices via QuestionOptions. This is so that the data which option choice stores 
	(in name) can be reused by reference.

/
class OptionChoice < ActiveRecord::Base
	# has_many :questions, through: :question_options
	belongs_to :option_group
	has_many :question_options

	validates :option_group_id, presence: true
	validates :name, presence: true
end
