class ChangeChartsTable < ActiveRecord::Migration
  def change
  	change_column :charts, :question_id2, :integer
  	change_column :charts, :question_id3, :integer
  end
end
