class AddDetailsToCharts < ActiveRecord::Migration
  def change
    add_column :charts, :type_id, :string
    add_column :charts, :question_id, :string
  end
end
