class SetUserFlag < ActiveRecord::Migration
  def change
  	add_column :users, :is_creator, :boolean, default: false
  end
end
