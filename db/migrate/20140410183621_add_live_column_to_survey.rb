class AddLiveColumnToSurvey < ActiveRecord::Migration
  def change
  	add_column :surveys, :live, :boolean
  end
end
