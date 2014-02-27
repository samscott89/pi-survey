class QuestionType < ActiveRecord::Base
	belongs_to :groups, foreign_key: "type_id"
	validates :name, presence: true
end
