class AddOwnerIdToCharts < ActiveRecord::Migration
  def change
    add_column :charts, :owner_id, :integer
  end
end
