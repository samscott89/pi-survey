class CreateSurveyHeaders < ActiveRecord::Migration
  def change
    create_table :survey_headers do |t|
      t.string :name
      t.text :instructions

      # t.timestamps
    end
  end
end
