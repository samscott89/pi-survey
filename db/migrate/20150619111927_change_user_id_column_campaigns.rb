class ChangeUserIdColumnCampaigns < ActiveRecord::Migration
  def change
  	rename_column :campaigns, :user_id, :owner_id
  end
end
