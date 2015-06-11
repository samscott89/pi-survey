class CreateAnswerOptions < ActiveRecord::Migration
  def change
    create_table :answer_options do |t|
      t.integer :answer_id
      t.integer :option_id

      t.timestamps
    end
  end
end
