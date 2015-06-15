class AddCustomOptionToQuestions < ActiveRecord::Migration
  def change
  	add_column :questions, :allow_other, :boolean, default: false
  end
end
