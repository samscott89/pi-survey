class ChangeDeletedColumnCampaigns < ActiveRecord::Migration
  def change
  	change_column :campaigns, :deleted, :boolean, default: false

  	add_index :campaigns, [:deleted], name: "index_campaigns_on_deleted"
  end
end
