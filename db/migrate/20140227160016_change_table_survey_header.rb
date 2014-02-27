class ChangeTableSurveyHeader < ActiveRecord::Migration
  def change
  	rename_table :survey_headers, :surveys
  end
end
