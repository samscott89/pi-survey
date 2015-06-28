
namespace :db do
  desc "Fill the database with realistic surveys"
  task populate_survey: :environment do

    survey = Survey.create!(name: "Example Survey", description: "This is an example survey.", is_public: true, owner_id: User.find_by(email: "guest@example.com").id)
    	
  	sec = SurveySection.create!(name: "Section 1", title: "Introduction", required: true, survey: survey, idx: 1)
  	q = Question.create!(survey_section: sec, name: "Name", subtext: "What is your name?", option_group: g_text)
  	q.question_options.create(option_choice: simple_text)

  	q = Question.create!(survey_section: sec, name: "Age", subtext: "What is your age?", option_group: g_radio)
  	for n in ["0-15", "16-25", "25-30", "31+"] do
    		age_choice = OptionChoice.create!(choice_name: "#{n}", option_group: g_radio)
    		q.question_options.create(option_choice: age_choice)
  	end
    	
    	q = Question.create!(survey_section: sec, name: "Date", subtext: "What is the date?", option_group: g_date)
    	q.question_options.create(option_choice: simple_date)

    	q = Question.create!(survey_section: sec, name: "Sports", subtext: "What sports do you play?", option_group: g_check)
    	for sp in ["football", "cricket", "basketball", "rugby"] do
    		sport_choice = OptionChoice.create!(choice_name: sp, option_group: g_check)
    		q.question_options.create(option_choice: sport_choice)
  	end

  	q = Question.create!(survey_section: sec, name: "Select", subtext: "Select an option", option_group: g_select)
    	select_choices.each do |str, choice|
    		q.question_options.create(option_choice: choice)
    	end

    	sec = SurveySection.create!(name: "Section 2", title: "Random Things", required: false, survey: survey, idx: 2)
    	3.times do 
    		q = Question.create!(survey_section: sec, name: Faker::Lorem.word, subtext: Faker::Lorem.sentence, option_group: g_radio)
    		radio_choices.each do |str, choice|
    			q.question_options.create(option_choice: choice)
    		end
    	end



  end
end