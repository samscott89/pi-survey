class DeleteOptionIdColumnFromAnswers < ActiveRecord::Migration
  def change
  	remove_index :answers, "user_id_and_option_id"
  	remove_column :answers, :option_id
  end
end
