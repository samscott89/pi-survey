class AddExtraQuestionIdsToCharts < ActiveRecord::Migration
  def change
    add_column :charts, :question_id2, :string
    add_column :charts, :question_id3, :string
  end
end
