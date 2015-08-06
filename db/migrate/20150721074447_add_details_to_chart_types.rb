class AddDetailsToChartTypes < ActiveRecord::Migration
  def change
    add_column :chart_types, :type, :string
    add_column :chart_types, :is_multiple, :boolean
  end
end
