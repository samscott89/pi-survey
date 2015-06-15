class AddHasOtherColumnToAnswer < ActiveRecord::Migration
  def change
    add_column :answers, :has_other, :boolean, default: false
  end
end
