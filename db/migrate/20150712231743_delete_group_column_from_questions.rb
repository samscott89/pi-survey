class DeleteGroupColumnFromQuestions < ActiveRecord::Migration
  def change
  	remove_column :questions, :group_id
  end
end
