class CreateQuestionBlanks < ActiveRecord::Migration
  def change
    create_table :question_blanks do |t|
      t.string :value
      t.integer :question_id
      t.timestamps


    end
 
	add_index :question_blanks, :question_id
 
  end
end
