class ChangeOwnerToOwnerId < ActiveRecord::Migration
  def change
  	rename_column :surveys, :owner, :owner_id
  end
end
