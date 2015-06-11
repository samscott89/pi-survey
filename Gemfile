source 'https://rubygems.org'
ruby '2.0.0'

gem 'rails', '4.0.3'

group :development, :test do
  gem 'sqlite3', '1.3.8'
  gem 'rspec-rails', '2.13.1'
  gem 'better_errors'
  gem "binding_of_caller" #More error handling stuff
end

group :test do
  gem 'selenium-webdriver', '2.35.1'
  gem 'capybara', '2.1.0'
  gem 'factory_girl_rails', '4.1.0'
end

gem 'bootstrap-sass', '3.2.0' # pretty CSS
gem 'sass-rails', '4.0.3' # More CSS trickery
gem 'bcrypt-ruby', '3.1.2' # security
gem 'faker', '1.1.2' # populates db with fake data
gem 'sprockets', '2.11.0'

gem 'uglifier', '2.1.1'
gem 'coffee-rails', '4.0.1'
gem 'coffee-script-source', '1.8.0'

gem 'jquery-rails', '3.0.4'
gem 'turbolinks', '1.1.1'
gem 'jbuilder', '1.0.2'

gem 'rest_in_place'

gem 'devise' # Password authentication stuff
gem 'kaminari'

group :doc do
  gem 'sdoc', '0.3.20', require: false
end

group :production do
  gem 'sqlite3', '1.3.8' #keep production on sqlite for now
  #gem 'pg', '0.15.1'
  gem 'rails_12factor', '0.0.2'
end
