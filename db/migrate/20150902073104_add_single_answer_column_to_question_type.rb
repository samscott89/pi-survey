class AddSingleAnswerColumnToQuestionType < ActiveRecord::Migration
  def change
  	add_column :questions, :max_answers, :integer, default: 0
  end
end
