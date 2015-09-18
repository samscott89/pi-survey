class ChangeDefaultDeletedAt < ActiveRecord::Migration
  def change
  	change_column :answers, :deleted_at, :datetime, default: nil, null: true
  	change_column :questions, :deleted_at, :datetime, default: nil, null: true
  	change_column :surveys, :deleted_at, :datetime, default: nil, null: true
  	change_column :survey_sections, :deleted_at, :datetime, default: nil, null: true
  	change_column :users, :deleted_at, :datetime, default: nil, null: true
  end
end
