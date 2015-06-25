
namespace :db do
  desc "Fill the database with realistic surveys"
  task fake_answers: :environment do

    # # Change this to desired target, or make it input.
    # survey_target_id = 6 

    # questions = Survey.find(survey_target_id).sections.collect {|sec| sec.questions }
    # questions.flatten

    users = []
    100.times do
       users << User.create(name: Faker::Name.name, email: Faker::Internet.email, password: "password")
    end

    users.each do |u|
      Answer.create!(user_id: u.id, question_id: 1, answer_options_attributes:
                         {"0" => {answer_text: u.name, option_id: 1}})
      Answer.create!(user_id: u.id, question_id: 2, answer_options_attributes: 
                        {"0" => {option_id: rand(2..5)}})
      Answer.create!(user_id: u.id, question_id: 3, answer_options_attributes: 
                        {"0" => {answer_text: Time.now + rand(-10..10)*60*60*24, option_id: 6}})
      a = Answer.new(user_id: u.id, question_id: 4)
      7..10.each do |n|
        a.answer_options.build(option_id: n) if rand(0) == 0
      end
      a.save

      Answer.create!(user_id: u.id, question_id: 5, answer_options_attributes: {"0" => {option_id: rand(11..13)}})
      Answer.create!(user_id: u.id, question_id: 6, answer_options_attributes: {"0" => {option_id: rand(14..18)}})
      Answer.create!(user_id: u.id, question_id: 7, answer_options_attributes: {"0" => {option_id: rand(19..23)}})
      Answer.create!(user_id: u.id, question_id: 8, answer_options_attributes: {"0" => {option_id: rand(24..28)}})
    end

  end
end