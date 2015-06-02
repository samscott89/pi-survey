class ChangeTemporaryFlagInUsersTable < ActiveRecord::Migration
  def change
  	change_column :users, :temporary, :boolean, default: false
  end
end
