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

ActiveRecord::Schema.define(version: 20160225202000) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", id: false, force: :cascade do |t|
    t.datetime "created_at"
    t.integer  "user_id"
    t.integer  "assignor_id"
  end

  add_index "admins", ["assignor_id"], name: "index_admins_on_assignor_id", using: :btree
  add_index "admins", ["user_id"], name: "index_admins_on_user_id", using: :btree

  create_table "productions", force: :cascade do |t|
    t.string   "title"
    t.string   "alphabetise"
    t.string   "url"
    t.date     "first_date"
    t.date     "press_date"
    t.date     "last_date"
    t.boolean  "press_date_tbc"
    t.boolean  "previews_only"
    t.integer  "dates_info",         limit: 2
    t.string   "press_date_wording"
    t.string   "dates_tbc_note"
    t.string   "dates_note"
    t.date     "second_press_date"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "creator_id"
    t.integer  "updater_id"
  end

  add_index "productions", ["creator_id"], name: "index_productions_on_creator_id", using: :btree
  add_index "productions", ["updater_id"], name: "index_productions_on_updater_id", using: :btree
  add_index "productions", ["url"], name: "index_productions_on_url", using: :btree

  create_table "super_admins", id: false, force: :cascade do |t|
    t.datetime "created_at"
    t.integer  "user_id"
  end

  add_index "super_admins", ["user_id"], name: "index_super_admins_on_user_id", using: :btree

  create_table "suspensions", id: false, force: :cascade do |t|
    t.datetime "created_at"
    t.integer  "user_id"
    t.integer  "assignor_id"
  end

  add_index "suspensions", ["assignor_id"], name: "index_suspensions_on_assignor_id", using: :btree
  add_index "suspensions", ["user_id"], name: "index_suspensions_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "activation_digest"
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.string   "remember_digest"
    t.datetime "remember_created_at"
    t.datetime "current_log_in_at"
    t.datetime "last_log_in_at"
    t.integer  "log_in_count"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "creator_id"
    t.integer  "updater_id"
  end

  add_index "users", ["creator_id"], name: "index_users_on_creator_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["updater_id"], name: "index_users_on_updater_id", using: :btree

  add_foreign_key "admins", "users"
  add_foreign_key "admins", "users", column: "assignor_id"
  add_foreign_key "productions", "users", column: "creator_id"
  add_foreign_key "productions", "users", column: "updater_id"
  add_foreign_key "super_admins", "users"
  add_foreign_key "suspensions", "users"
  add_foreign_key "suspensions", "users", column: "assignor_id"
  add_foreign_key "users", "users", column: "creator_id"
  add_foreign_key "users", "users", column: "updater_id"
end
