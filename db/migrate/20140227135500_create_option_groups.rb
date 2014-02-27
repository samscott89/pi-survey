class CreateOptionGroups < ActiveRecord::Migration
  def change
    create_table :option_groups do |t|
      t.string :name
      t.integer :type_id

      # t.timestamps
    end
    add_index :option_groups, :type_id
  end
end
