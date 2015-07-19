class AddIsMultipleToQuestionType < ActiveRecord::Migration
  def change
    add_column :question_types, :is_multiple, :boolean
  end
end
