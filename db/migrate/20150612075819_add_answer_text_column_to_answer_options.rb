class AddAnswerTextColumnToAnswerOptions < ActiveRecord::Migration
  def change
  	add_column :answer_options, :answer_text, :text
  end
end
