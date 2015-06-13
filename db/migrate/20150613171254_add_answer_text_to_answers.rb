class AddAnswerTextToAnswers < ActiveRecord::Migration
  def change
  	add_column :answers, :answer_text, :text
  end
end
