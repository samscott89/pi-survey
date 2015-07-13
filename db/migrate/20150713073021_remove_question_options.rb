class RemoveQuestionOptions < ActiveRecord::Migration
  def change
  	drop_table :question_options

  	remove_column :questions, :question_type_id
  end
end
