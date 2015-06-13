class RemoveLiveColumnFromSurvey < ActiveRecord::Migration
  def change
  	remove_column :surveys, :live
  end
end
