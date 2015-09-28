
namespace :db do
  desc "Fill the database with realistic surveys"
  task populate_survey: :environment do

    survey = Survey.create!(name: "Example Survey", description: "This is an example survey.", is_public: true, owner_id: User.find_by(email: "guest@example.com").id)
    	
  	sec = SurveySection.create!(name: "Section 1", title: "Introduction", required: true, survey: survey, idx: 1)
  	q = Question.new(survey_section: sec, name: "Name", subtext: "What is your name?")
    q.option_group = OptionGroup.find_by(name: "SimpleTextEntry").deep_copy
    q.save!

  	q = Question.new(survey_section: sec, name: "Age", subtext: "What is your age?")
  	q.option_group = OptionGroup.new(question_type: QuestionType.find_by(name: "radio_button"))
    for n in ["0-15", "16-25", "26-35", "36+"] do
    		q.option_group.option_choices.build(choice_name: "#{n}")
  	end
    q.save!
    	
  	q = Question.new(survey_section: sec, name: "Date", subtext: "What is the date?")
    q.option_group = OptionGroup.find_by(name: "SimpleDate").deep_copy
    q.save!

  	q = Question.new(survey_section: sec, name: "Sports", subtext: "What sports do you play?")
    q.option_group = OptionGroup.new(question_type: QuestionType.find_by(name: "check_box"))
  	for sp in ["football", "cricket", "basketball", "rugby"] do
      q.option_group.option_choices.build(choice_name: sp)
  	end
    q.save!

  	q = Question.new(survey_section: sec, name: "Select", subtext: "Select an option")
    q.option_group = OptionGroup.new(question_type: QuestionType.find_by(name: "select"))
  	["first", "second", "third"].each do |choice|
  		q.option_group.option_choices.build(choice_name: choice)
  	end
    q.save!

  	sec = SurveySection.create!(name: "Section 2", title: "Random Things", required: false, survey: survey, idx: 2)
  	3.times do 
  		q = Question.new(survey_section: sec, name: Faker::Lorem.word, subtext: Faker::Lorem.sentence)
      q.option_group = OptionGroup.new(question_type: QuestionType.find_by(name: "check_box"))
      4.times do 
        q.option_group.option_choices.build(choice_name: Faker::Lorem.word)
      end
      q.save!
  	end
    puts "Created example survey."
  end
end