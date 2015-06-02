class AddTemporaryFlagToUsersTable < ActiveRecord::Migration
  def change
  	add_column :users, :temporary, :boolean
  end
end
