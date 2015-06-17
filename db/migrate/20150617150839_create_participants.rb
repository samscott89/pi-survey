class CreateParticipants < ActiveRecord::Migration
  def change
    create_table :participants do |t|
      t.integer :user_id
      t.integer :campaign_id

      t.timestamps
    end

    add_index :participants, :campaign_id, name: "index_participants_on_campaign_id"
    add_index :participants, :user_id, name: "index_participants_on_user_id"
  end
end
