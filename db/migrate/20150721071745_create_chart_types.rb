class CreateChartTypes < ActiveRecord::Migration
  def change
    create_table :chart_types do |t|

      t.timestamps
    end
  end
end
