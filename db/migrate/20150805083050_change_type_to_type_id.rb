class ChangeTypeToTypeId < ActiveRecord::Migration
  def change
  	rename_column :chart_types, :type, :type_id
  end
end
