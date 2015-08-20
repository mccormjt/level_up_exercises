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

ActiveRecord::Schema.define(version: 20150820194106) do

  create_table "assignments", force: :cascade do |t|
    t.integer  "task_id",        null: false
    t.integer  "recipient_id",   null: false
    t.integer  "guid",           null: false
    t.float    "followup_hours"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "assignments", ["recipient_id", "guid"], name: "index_assignments_on_recipient_id_and_guid", unique: true
  add_index "assignments", ["task_id", "recipient_id"], name: "index_assignments_on_task_id_and_recipient_id", unique: true

  create_table "recipients", force: :cascade do |t|
    t.string   "name",         default: "", null: false
    t.string   "phone_number", default: "", null: false
    t.integer  "user_id",                   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "recipients", ["phone_number"], name: "index_recipients_on_phone_number", unique: true
  add_index "recipients", ["user_id", "phone_number"], name: "index_recipients_on_user_id_and_phone_number", unique: true

  create_table "statuses", force: :cascade do |t|
    t.integer  "state",         default: 0, null: false
    t.integer  "assignment_id",             null: false
    t.text     "message"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "statuses", ["assignment_id"], name: "index_statuses_on_assignment_id"

  create_table "tasks", force: :cascade do |t|
    t.integer  "user_id",                                    null: false
    t.string   "subject",                                    null: false
    t.date     "due_date",                                   null: false
    t.float    "estimated_completion_hours",                 null: false
    t.text     "description",                                null: false
    t.boolean  "archived",                   default: false, null: false
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "tasks", ["archived"], name: "index_tasks_on_archived"
  add_index "tasks", ["user_id"], name: "index_tasks_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "encrypted_password",     default: "", null: false
    t.string   "phone_number",           default: "", null: false
    t.string   "name",                   default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["phone_number"], name: "index_users_on_phone_number", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
