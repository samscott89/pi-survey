class AddRowOrderToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :row_order, :integer
  end
end
