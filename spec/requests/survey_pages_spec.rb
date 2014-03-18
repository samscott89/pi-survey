require 'spec_helper'
include ApplicationHelper

describe "Survey pages" do

  subject { page }

  describe "show surveys" do
    before { visit surveys_path}

    it { should have_title(full_title('All surveys')) }
    it { should have_content('All surveys') }

  end

  describe "survey_path" do
    let(:survey) { create_survey }
    before { visit survey_path(survey) }

    it { should have_content( survey.instructions) }
    it { should have_title(full_title(survey.name)) }

    it { should have_link('Start survey', href: survey_section_path(survey, survey.sections.first)) }
  end
end


# describe "SurveySection pages" do

#   subject{ page }

#   describe "show survey_sections" do
#     let(:survey) { create_survey}
#     let(:section) { survey.sections.first}
#     let(:button_text) {"Submit answer"}

#     before { visit survey_section_path(section, 1)}

#     it { should have_selector("h1", section.title) }

#     describe "when user is not logged in" do
#       before do
#         within("form") {click_button(button_text)}
#       end
#       it {should_not be_valid}
#     end

#     let(:user) {FactoryGirl.create(:user)}
#     before {sign_in user}

#     describe "when survey is blank" do
#       before {click_button button_text}

#       it {should have_content('error')}
#     end
#   end

# end

#   # describe "signup" do

  #   before { visit signup_path }

  #   let(:submit) { "Create account" }

  #   describe "with invalid information" do
  #     it "should not create a user" do
  #       expect { click_button submit }.not_to change(User, :count)
  #     end
  #   end

  #   describe "with valid information" do
  #     before do
  #       fill_in "Name",         with: "Example User"
  #       fill_in "Email",        with: "user@example.com"
  #       fill_in "Password",     with: "foobar"
  #       fill_in "Confirm Password", with: "foobar"
  #     end

  #     it "should create a user" do
  #       expect { click_button submit }.to change(User, :count).by(1)
  #     end

  #     describe "after saving the user" do
  #       before { click_button submit }
  #       let(:user) { User.find_by(email: 'user@example.com') }

  #       it { should have_link('Sign out') }
  #       it { should have_title(user.name) }
  #       it { should have_selector('div.alert.alert-success', text: 'Welcome') }

  #       describe "followed by signout" do
  #         before { click_link "Sign out" }
  #         it { should have_link('Sign in') }
  #       end
  #     end
  #   end
  # end


  # describe "profile page" do
  #   let(:user) { FactoryGirl.create(:user) }
  #   before { visit user_path(user) }

  #   it { should have_selector('h1',    text: user.name) }
  #  it { should have_title(full_title(user.name)) }
  # end

  #  describe "edit" do
  #   let(:user) { FactoryGirl.create(:user) }
  #   before do
  #     sign_in user
  #     visit edit_user_path(user)
  #   end

  #   describe "page" do
  #     it { should have_content("Update your profile") }
  #     it { should have_title("Edit user") }
  #   end

  #   describe "with invalid information" do
  #     before { click_button "Save changes" }

  #     it { should have_content('error') }
  #   end

  #   describe "with valid information" do
  #     let(:new_name)  { "New Name" }
  #     let(:new_email) { "new@example.com" }
  #     before do
  #       fill_in "Name",             with: new_name
  #       fill_in "Email",            with: new_email
  #       fill_in "Password",         with: user.password
  #       fill_in "Confirm Password", with: user.password
  #       click_button "Save changes"
  #     end

  #     it { should have_title(new_name) }
  #     it { should have_selector('div.alert.alert-success') }
  #     it { should have_link('Sign out', href: signout_path) }
  #     specify { expect(user.reload.name).to  eq new_name }
  #     specify { expect(user.reload.email).to eq new_email }
  #   end
  # end

  # describe "index" do
  #   let(:user) { FactoryGirl.create(:user) }
  #   before(:each) do
  #     sign_in user
  #     visit users_path
  #   end

  #   it { should have_title('All users') }
  #   it { should have_content('All users') }

  #   describe "pagination" do

  #     before(:all) { 30.times { FactoryGirl.create(:user) } }
  #     after(:all)  { User.delete_all }

  #     it { should have_selector('div.pagination') }

  #     it "should list each user" do
  #       User.paginate(page: 1).each do |user|
  #         expect(page).to have_selector('li', text: user.name)
  #       end
  #     end
  #   end

  #   describe "delete links" do

  #     it { should_not have_link('delete') }

  #     describe "as an admin user" do
  #       let(:admin) { FactoryGirl.create(:admin) }
  #       before do
  #         sign_in admin
  #         visit users_path
  #       end

  #       it { should have_link('delete', href: user_path(User.first)) }
  #       it "should be able to delete another user" do
  #         expect do
  #           click_link('delete', match: :first)
  #         end.to change(User, :count).by(-1)
  #       end
  #       it { should_not have_link('delete', href: user_path(admin)) }
  #     end
  #   end

  # end
# end