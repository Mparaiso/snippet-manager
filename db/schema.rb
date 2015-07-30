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

ActiveRecord::Schema.define(version: 20150730214343) do

  create_table "categories", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "description"
  end

  add_index "categories", ["title"], name: "index_categories_on_title"

  create_table "snippets", force: :cascade do |t|
    t.string   "title",       null: false
    t.string   "content",     null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "category_id"
    t.integer  "user_id"
  end

  add_index "snippets", ["category_id"], name: "index_snippets_on_category_id"
  add_index "snippets", ["user_id"], name: "index_snippets_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "auth_token"
    t.datetime "auth_token_expiration"
    t.string   "password_digest"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "nickname"
  end

  add_index "users", ["email"], name: "index_users_on_email"

end
