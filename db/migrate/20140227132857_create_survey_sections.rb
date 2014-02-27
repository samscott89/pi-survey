class CreateSurveySections < ActiveRecord::Migration
  def change
    create_table :survey_sections do |t|
      t.string :name
      t.integer :survey_id
      t.string :title
      t.string :subtitle
      t.boolean :req

      # t.timestamps
    end
    add_index :survey_sections, :survey_id
  end
end
