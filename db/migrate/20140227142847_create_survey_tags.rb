class CreateSurveyTags < ActiveRecord::Migration
  def change
    create_table :survey_tags do |t|
      t.integer :survey_id
      t.integer :tag_id

      t.timestamps
    end
    add_index :survey_tags, :survey_id
    add_index :survey_tags, :tag_id
    add_index :survey_tags, [:survey_id, :tag_id], unique: true
  end
end
