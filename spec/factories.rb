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
end

FactoryGirl.define do
	factory :survey do
		name "Example Survey"
		instructions "Some description about what the survey will be like"
	end
end

FactoryGirl.define do
	factory :tag do
		sequence(:name) { |n| "tag #{n}"}
	end
end

FactoryGirl.define do
	factory :survey_section do
		sequence(:name) { |n| "Section #{n}" }
		sequence(:title) { |n| "Survey Section #{n}" }
		subtitle "The subtitle"
		required true
	end
end

FactoryGirl.define do
	factory :question do
		sequence(:name) { |n| "Q#{n}" }
		subtext "Answer the question"
		required { rand(2) == 1 }
	end
end

FactoryGirl.define do
	factory :option_group do
		sequence(:name) {|n| "Group #{n}"}
	end
end

FactoryGirl.define do
	factory :question_type do
		name "Checkbox"
	end
end
