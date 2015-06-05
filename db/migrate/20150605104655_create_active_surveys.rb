class CreateActiveSurveys < ActiveRecord::Migration
  def change
    create_table :active_surveys do |t|
      t.integer :survey_id
      t.integer :user_id
      t.boolean :completed

      t.timestamps
    end
  end
end
