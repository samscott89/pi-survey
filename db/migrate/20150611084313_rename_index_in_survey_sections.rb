class RenameIndexInSurveySections < ActiveRecord::Migration
  def change
  	rename_column :survey_sections, :index, :idx
  end
end
