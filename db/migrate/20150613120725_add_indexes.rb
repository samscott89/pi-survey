class AddIndexes < ActiveRecord::Migration
  def change
  	add_index :active_surveys, :user_id, name:  "index_active_surveys_on_user_id"
  	add_index :active_surveys, :survey_id, name:  "index_active_surveys_on_survey_id"

  	add_index :answer_options, :answer_id, name: "index_answer_options_on_answer_id"

  	add_index :answers, :question_id, name: "index_answers_on_question_id"
  	add_index :answers, :user_id, name: "index_answers_on_user_id"

  	add_index :survey_sections, :survey_id, name: "index_survey_sections_on_survey_id"

  	add_index :surveys, :owner_id, name: "index_surveys_on_owner_id"  	
  end
end
