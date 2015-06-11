# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150611111812) do

  create_table "active_surveys", force: true do |t|
    t.integer  "survey_id"
    t.integer  "user_id"
    t.boolean  "completed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "answer_options", force: true do |t|
    t.integer  "answer_id"
    t.integer  "option_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "answers", force: true do |t|
    t.integer  "user_id"
    t.integer  "answer_numeric"
    t.text     "answer_text"
    t.boolean  "answer_boolean"
    t.integer  "unit_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "question_id"
  end

  create_table "option_choices", force: true do |t|
    t.integer "option_group_id"
    t.string  "choice_name"
  end

  add_index "option_choices", ["option_group_id"], name: "index_option_choices_on_option_group_id"

  create_table "option_groups", force: true do |t|
    t.string  "name"
    t.integer "type_id"
  end

  add_index "option_groups", ["type_id"], name: "index_option_groups_on_type_id"

  create_table "question_blanks", force: true do |t|
    t.string   "value"
    t.integer  "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "question_blanks", ["question_id"], name: "index_question_blanks_on_question_id"

  create_table "question_options", force: true do |t|
    t.integer "question_id"
    t.integer "option_choice_id"
  end

  add_index "question_options", ["question_id"], name: "index_question_options_on_question_id"

  create_table "question_types", force: true do |t|
    t.string "name"
  end

  create_table "questions", force: true do |t|
    t.string  "name"
    t.integer "survey_section_id"
    t.text    "subtext"
    t.boolean "required"
    t.integer "group_id"
  end

  add_index "questions", ["survey_section_id"], name: "index_questions_on_survey_section_id"

  create_table "survey_sections", force: true do |t|
    t.string  "name"
    t.integer "survey_id"
    t.string  "title"
    t.string  "subtitle"
    t.boolean "required"
    t.integer "idx"
  end

  add_index "survey_sections", ["survey_id", "idx"], name: "index_survey_sections_on_survey_id_and_idx", unique: true

  create_table "survey_tags", force: true do |t|
    t.integer  "survey_id"
    t.integer  "tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "survey_tags", ["survey_id", "tag_id"], name: "index_survey_tags_on_survey_id_and_tag_id", unique: true
  add_index "survey_tags", ["survey_id"], name: "index_survey_tags_on_survey_id"
  add_index "survey_tags", ["tag_id"], name: "index_survey_tags_on_tag_id"

  create_table "surveys", force: true do |t|
    t.string  "name"
    t.text    "instructions"
    t.text    "description"
    t.boolean "live"
    t.integer "owner_id"
  end

  create_table "tags", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "unit_of_measurements", force: true do |t|
    t.string "name"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",                  default: false
    t.boolean  "temporary",              default: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
