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

ActiveRecord::Schema.define(version: 20150713073021) do

  create_table "active_surveys", force: true do |t|
    t.integer  "survey_id"
    t.integer  "user_id"
    t.boolean  "completed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "campaign_survey_id"
  end

  add_index "active_surveys", ["survey_id"], name: "index_active_surveys_on_survey_id"
  add_index "active_surveys", ["user_id"], name: "index_active_surveys_on_user_id"

  create_table "answer_options", force: true do |t|
    t.integer  "answer_id"
    t.integer  "option_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "answer_text"
  end

  add_index "answer_options", ["answer_id"], name: "index_answer_options_on_answer_id"

  create_table "answers", force: true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "question_id"
    t.boolean  "deleted",     default: false
    t.text     "answer_text"
    t.boolean  "has_other",   default: false
  end

  add_index "answers", ["deleted"], name: "index_answers_on_deleted"
  add_index "answers", ["question_id"], name: "index_answers_on_question_id"
  add_index "answers", ["user_id"], name: "index_answers_on_user_id"

  create_table "campaign_surveys", force: true do |t|
    t.integer  "campaign_id"
    t.integer  "survey_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "campaign_surveys", ["campaign_id"], name: "index_campaign_surveys_on_campaign_id"

  create_table "campaigns", force: true do |t|
    t.string   "name"
    t.integer  "owner_id"
    t.boolean  "live"
    t.boolean  "deleted",    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "campaigns", ["deleted"], name: "index_campaigns_on_deleted"
  add_index "campaigns", ["owner_id"], name: "index_campaigns_on_owner_id"

  create_table "option_choices", force: true do |t|
    t.integer "option_group_id"
    t.string  "choice_name"
  end

  add_index "option_choices", ["option_group_id"], name: "index_option_choices_on_option_group_id"

  create_table "option_groups", force: true do |t|
    t.string  "name"
    t.integer "type_id"
    t.integer "question_id"
  end

  add_index "option_groups", ["question_id"], name: "index_option_group_on_question_id"
  add_index "option_groups", ["type_id"], name: "index_option_groups_on_type_id"

  create_table "participants", force: true do |t|
    t.integer  "user_id"
    t.integer  "campaign_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "participants", ["campaign_id"], name: "index_participants_on_campaign_id"
  add_index "participants", ["user_id"], name: "index_participants_on_user_id"

  create_table "question_types", force: true do |t|
    t.string  "name"
    t.boolean "is_multiple"
  end

  create_table "questions", force: true do |t|
    t.string  "name"
    t.integer "survey_section_id"
    t.text    "subtext"
    t.boolean "required"
    t.boolean "deleted",           default: false
    t.boolean "allow_other",       default: false
  end

  add_index "questions", ["deleted"], name: "index_questions_on_deleted"
  add_index "questions", ["survey_section_id"], name: "index_questions_on_survey_section_id"

  create_table "survey_sections", force: true do |t|
    t.string  "name"
    t.integer "survey_id"
    t.string  "title"
    t.string  "subtitle"
    t.boolean "required"
    t.integer "idx"
    t.boolean "deleted",   default: false
  end

  add_index "survey_sections", ["survey_id", "idx"], name: "index_survey_sections_on_survey_id_and_idx", unique: true
  add_index "survey_sections", ["survey_id"], name: "index_survey_sections_on_survey_id"

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
    t.integer "owner_id"
    t.boolean "is_public",    default: false
    t.boolean "deleted",      default: false
  end

  add_index "surveys", ["deleted"], name: "index_survey_sections_on_deleted"
  add_index "surveys", ["deleted"], name: "index_surveys_on_deleted"
  add_index "surveys", ["owner_id"], name: "index_surveys_on_owner_id"

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
    t.boolean  "deleted",                default: false
  end

  add_index "users", ["deleted"], name: "index_users_on_deleted"
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
