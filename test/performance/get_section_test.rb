require 'test_helper'
require 'rails/performance_test_help'
require 'rake'
system("RAILS_ENV=test rake db:seed")
system("RAILS_ENV=test rake db:populate_survey")

class GetSectionTest < ActionDispatch::PerformanceTest
  def test_survey_page
    get '/surveys/1/sec/1'
  end
end
