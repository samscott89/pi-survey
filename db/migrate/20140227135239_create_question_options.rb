class CreateQuestionOptions < ActiveRecord::Migration
  def change
    create_table :question_options do |t|
      t.integer :question_id
      t.integer :option_choice_id

      # t.timestamps
    end
    add_index :question_options, :question_id
  end
end
