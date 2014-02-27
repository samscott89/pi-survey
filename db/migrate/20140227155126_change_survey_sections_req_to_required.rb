class ChangeSurveySectionsReqToRequired < ActiveRecord::Migration
  def change
  	change_table :survey_sections do |t|
  		t.rename :req, :required
  	end
  end
end
