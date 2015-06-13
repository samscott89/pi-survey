class RemoveColumnsFromAnswers < ActiveRecord::Migration
  def change
  	remove_column :answers, :answer_text
  	remove_column :answers, :answer_numeric
  	remove_column :answers, :answer_boolean
  	remove_column :answers, :unit_id  	
  end
end
