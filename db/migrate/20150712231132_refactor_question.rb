class RefactorQuestion < ActiveRecord::Migration
  def change
  	add_column :questions, :question_type_id, :integer

  	add_column :option_groups, :question_id, :integer

  	add_index :option_groups, [:question_id], name: "index_option_group_on_question_id"
  end
end
