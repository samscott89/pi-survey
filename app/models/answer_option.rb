/
This is basically a parallel of QestionOption:
This helps connect a single answer or response to a multitude of answers.
/
class AnswerOption < ActiveRecord::Base
	belongs_to :answer
	belongs_to :question_option, foreign_key: "option_id"
end
