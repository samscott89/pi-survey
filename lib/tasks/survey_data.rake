
namespace :db do
  desc "Fill the database with realistic surveys"
  task populate_survey: :environment do
  	#Add realistic survey data here 

  	possible_types = ["check_box", "radio_button", "text_field", "text_area", "select", "select_multiple", "collection_select", "date_field", "datetime_field", "time_field"]
  	possible_types.each do |t|
  		QuestionType.create(name: t)
  	end

  	#Creates some generic option choices
  	g_text = OptionGroup.create!(name: "SimpleTextEntry", question_type: QuestionType.find_by(name: "text_field"))
  	simple_text = OptionChoice.create!(choice_name: "other", option_group: g_text)

  	g_num = OptionGroup.create!(name: "SimpleNumericEntry", question_type: QuestionType.find_by(name: "text_field"))
  	simple_number = OptionChoice.create!(choice_name: "other", option_group: g_num)

  	g_radio = OptionGroup.create!(name: "SimpleNumberChoice", question_type: QuestionType.find_by(name: "radio_button"))
  	radio_choices = {}
  	for n in 1..5 do
  		radio_choices[n] = OptionChoice.create!(choice_name: "#{n}", option_group: g_radio)
	end

	g_check = OptionGroup.create!(name: "SimpleCheckBox", question_type: QuestionType.find_by(name: "check_box"))
	check_choices = {}
	["a", "b", "c", "d"].each do |str|
		check_choices[str] = OptionChoice.create!(choice_name: str, option_group: g_check)
	end

	g_select = OptionGroup.create!(name: "SimpleSelection", question_type: QuestionType.find_by(name: "select"))
	select_choices = {}
	["first", "second", "third"].each do |str|
		select_choices[str] = OptionChoice.create!(choice_name: str, option_group: g_select)
	end

	g_date = OptionGroup.create!(name: "SimpleDate", question_type: QuestionType.find_by(name: "date_field"))
	simple_date = OptionChoice.create!(choice_name: "SimpleDate", option_group: g_date)

  user = User.find_by(email: "guest@example.com")
  user ||= User.create(name: "Guest", email: "guest@example.com", password: "password");

  survey = Survey.create!(name: "Example Survey", description: "This is an example survey.", is_public: true, owner_id: user.id)
  	
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