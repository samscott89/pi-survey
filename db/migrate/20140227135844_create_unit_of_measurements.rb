class CreateUnitOfMeasurements < ActiveRecord::Migration
  def change
    create_table :unit_of_measurements do |t|
      t.string :name

      # t.timestamps
    end
  end
end
