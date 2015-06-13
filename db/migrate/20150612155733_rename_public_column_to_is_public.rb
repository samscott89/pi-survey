class RenamePublicColumnToIsPublic < ActiveRecord::Migration
  def change
  	rename_column :surveys, :public, :is_public
  end
end
