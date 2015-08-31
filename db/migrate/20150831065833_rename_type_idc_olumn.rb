class RenameTypeIdcOlumn < ActiveRecord::Migration
  def change
  	rename_column :chart_types, :type_id, :name 
  end
end
