class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :name
      t.integer :survey_section_id
      t.text :subtext
      t.boolean :required
      t.integer :group_id

      # t.timestamps
    end
    add_index :questions, :survey_section_id
  end
end
