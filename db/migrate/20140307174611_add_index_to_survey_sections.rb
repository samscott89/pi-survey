class AddIndexToSurveySections < ActiveRecord::Migration
  def change
  	add_column :survey_sections, :index, :integer, unique: true
  	add_index :survey_sections, :index
  end
end
