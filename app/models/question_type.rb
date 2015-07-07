/
  Question type is a simple object defining the different types of 
  questions there can be: checkbox, text input etc.

  These have some predefined options, which are grouped together by question_groups.

  The question types are indexed by type_id in question_groups
/
class QuestionType < ActiveRecord::Base
	has_many :option_groups, foreign_key: "type_id"
	
	validates :name, presence: true, uniqueness: true

	scope :multiples, -> { where(is_multiple: true) }
end
