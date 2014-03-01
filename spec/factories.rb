FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "password"
    password_confirmation "password"

    factory :admin do
      admin true
    end
  end

	factory :survey do
		name "Example Survey"
		instructions "Some description about what the survey will be like"
	end

	factory :tag do
		sequence(:name) { |n| "tag #{n}"}
	end

	factory :survey_section do
		sequence(:name) { |n| "Section #{n}" }
		sequence(:title) { |n| "Survey Section #{n}" }
		subtitle "The subtitle"
		required true
	end

	factory :question do
		sequence(:name) { |n| "Q#{n}" }
		subtext "Answer the question"
		required { rand(2) == 1 }
	end

	factory :question_type do
		name ["Checkbox", "Radio buttons", "Text", "Numeric", "Slider"].sample
	end

	factory :option_group do
		sequence(:name) {|n| "Group #{n}"}
	end

	factory :option_choice do
		sequence(:name) { |n| "Option number #{n}"}
	end

	factory :answer do
		user_id 0
		answer_text "Some answer"
		option_id 0
	end
end

