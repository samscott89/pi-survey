class AddOwnerColumnToSurveys < ActiveRecord::Migration
  def change
  	add_column :surveys, :owner, :integer
  end
end
