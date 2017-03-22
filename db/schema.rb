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

ActiveRecord::Schema.define(version: 20170322032135) do

  create_table "ar_internal_metadata", primary_key: "key", force: :cascade do |t|
    t.string   "value",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "articles", force: :cascade do |t|
    t.integer  "user_id",            limit: 4
    t.integer  "original_author_id", limit: 4
    t.text     "content",            limit: 65535
    t.text     "title",              limit: 65535
    t.boolean  "published"
    t.string   "cover",              limit: 255
    t.integer  "category_id",        limit: 4
    t.integer  "replies_count",      limit: 4
    t.integer  "views_count",        limit: 4
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description", limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "images", force: :cascade do |t|
    t.string   "filename",   limit: 255
    t.integer  "user_id",    limit: 4
    t.string   "hash",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "profiles", force: :cascade do |t|
    t.string   "avatar",      limit: 255
    t.string   "location",    limit: 255
    t.string   "gender",      limit: 255
    t.string   "city",        limit: 255
    t.text     "description", limit: 65535
    t.integer  "age",         limit: 4
    t.integer  "user_id",     limit: 4
    t.date     "birthday"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                   limit: 255
    t.string   "email_activation_digest", limit: 255
    t.boolean  "email_verified",                      default: false
    t.string   "password_digest",         limit: 255,                 null: false
    t.datetime "activated_at"
    t.string   "remember_digest",         limit: 255
    t.integer  "sign_in_count",           limit: 4,   default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.string   "name",                    limit: 255
    t.string   "mobile",                  limit: 255
    t.boolean  "mobile_verified",                     default: false
    t.string   "reset_digest",            limit: 255
    t.datetime "reset_sent_at"
    t.string   "open_id",                 limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["mobile"], name: "index_users_on_mobile", unique: true, using: :btree
  add_index "users", ["name"], name: "index_users_on_nickname", unique: true, using: :btree

end
