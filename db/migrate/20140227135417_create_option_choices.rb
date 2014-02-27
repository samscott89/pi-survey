class CreateOptionChoices < ActiveRecord::Migration
  def change
    create_table :option_choices do |t|
      t.integer :option_group_id
      t.string :choice_name

      # t.timestamps
    end
    add_index :option_choices, :option_group_id
  end
end
