class CreateCampaignSurveys < ActiveRecord::Migration
  def change
    create_table :campaign_surveys do |t|
      t.integer :campaign_id
      t.integer :survey_id
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps
    end

    add_column :active_surveys, :campaign_survey_id, :integer
    add_index :campaign_surveys, :campaign_id, name: "index_campaign_surveys_on_campaign_id"
  end
end
