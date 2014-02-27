class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.integer :user_id
      t.integer :option_id
      t.integer :answer_numeric
      t.text :answer_text
      t.boolean :answer_boolean
      t.integer :unit_id

      t.timestamps
    end
    add_index :answers, [:user_id, :option_id], unique: true
    # add_index :answers, :option_id
  end
end
