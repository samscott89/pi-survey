class AddDeletedBooleanColumn < ActiveRecord::Migration
  def change
  	add_column :surveys, :deleted, :boolean, default: false
  	add_index :surveys, :deleted, name: "index_surveys_on_deleted"

  	add_column :survey_sections, :deleted, :boolean, default: false
  	add_index :surveys, :deleted, name: "index_survey_sections_on_deleted"

  	add_column :questions, :deleted, :boolean, default: false
  	add_index :questions, :deleted, name: "index_questions_on_deleted"

  	add_column :users, :deleted, :boolean, default: false
  	add_index :users, :deleted, name: "index_users_on_deleted"

  	add_column :answers, :deleted, :boolean, default: false
  	add_index :answers, :deleted, name: "index_answers_on_deleted"
  end
end
