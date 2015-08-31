class ChangeChartsTables < ActiveRecord::Migration
  def change
  	change_table :charts do |t|
  		t.remove :owner_id, :question_id2, :question_id3
		  t.change :type_id, :integer
  		t.change :question_id, :integer
  	end
  end
end
