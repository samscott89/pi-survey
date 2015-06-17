class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.string :name
      t.integer :user_id
      t.boolean :live
      t.boolean :deleted

      t.timestamps
    end

    add_index :campaigns, :user_id, name: "index_campaigns_on_user_id"
  end
end
