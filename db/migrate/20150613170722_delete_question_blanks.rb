class DeleteQuestionBlanks < ActiveRecord::Migration
  def change
  	drop_table :question_blanks
  end
end
