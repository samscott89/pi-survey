class ChangedDeletedColumns < ActiveRecord::Migration
  def change
  	remove_index :answers, column: :deleted
  	remove_index :answers, column: :question_id
  	remove_index :answers, column: :user_id
  	rename_column :answers, :deleted, :deleted_at
  	change_column :answers, :deleted_at, :datetime
  	add_index :answers, :question_id, where: "deleted_at IS NULL"
  	add_index :answers, :user_id, where: "deleted_at IS NULL"
  	
  	remove_column :campaigns, :deleted, :boolean

  	remove_index :questions, column: :deleted
  	remove_index :questions, column: :survey_section_id
  	rename_column :questions, :deleted, :deleted_at
  	change_column :questions, :deleted_at, :datetime
  	add_index :questions, :survey_section_id, where: "deleted_at IS NULL"

  	remove_index :surveys, column: :deleted
  	remove_index :surveys, column: :owner_id
  	rename_column :surveys, :deleted, :deleted_at
  	change_column :surveys, :deleted_at, :datetime

  	remove_index :survey_sections, column: :survey_id
  	remove_index :survey_sections, column: [:survey_id, :idx]
  	rename_column :survey_sections, :deleted, :deleted_at
  	change_column :survey_sections, :deleted_at, :datetime
  	add_index :survey_sections, :survey_id, where: "deleted_at IS NULL"
  	add_index :survey_sections, [:survey_id, :idx], where: "deleted_at IS NULL"
  	
  	remove_index :users, column: :deleted
  	rename_column :users, :deleted, :deleted_at
  	change_column :users, :deleted_at, :datetime
  end
end
