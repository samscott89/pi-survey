namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    User.create!(name: "Example User",
                 email: "person@example.com",
                 password: "foobar",
                 password_confirmation: "foobar")
    99.times do |n|
      name  = Faker::Name.name
      email = "person-#{n+1}@example.com"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
    admin = User.create!(name: "Admin",
                         email: "admin@example.com",
                         password: "foobar",
                         password_confirmation: "foobar",
                         admin: true)
  end
end