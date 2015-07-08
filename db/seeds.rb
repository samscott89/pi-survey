# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user = CreateAdminService.new.call
puts 'Created Admin User: ' << user.email


guest = User.find_by(email: "guest@example.com")
guest ||= User.create(name: "Guest", email: "guest@example.com", password: "password");
puts 'Created Guest User'

# Instantiate possible Question Types
possible_types = ["check_box", "radio_button", "text_field", "text_area", "select", "select_multiple", "collection_select", "date_field", "datetime_field", "time_field", "likert_scale"]
possible_types.each do |t|
	if t == "check_box" || t == "radio_button" || t == "select" || t == "select_multiple" || t == "collection_select" || t == "likert_scale"
		m = true
	else
		m = false
	end
	QuestionType.create(name: t, is_multiple: m)
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

g_likert = OptionGroup.create!(name: "SimpleScaleChoice", question_type: QuestionType.find_by(name: "likert_scale"))
likert_choices = {}
for n in 1..11 do
	likert_choices[n] = OptionChoice.create!(choice_name: "#{n}", option_group: g_likert)
end

puts "Created default survey data"