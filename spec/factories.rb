FactoryGirl.define do
  factory :user do
    name     "Sam Scott"
    email    "sam@scott.com"
    password "password"
    password_confirmation "password"
  end
end