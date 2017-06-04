class AddColumnsToUsers < ActiveRecord::Migration
  def change
    create_table "users", force: :cascade do |t|
    t.string   "email",               limit: 255, null: false
    t.string   "email_activation_digest",     limit: 255
    t.boolean  "email_verified",      default: false 
    t.string   "password_digest",     limit: 255, null: false
    t.datetime "activated_at"
    t.string   "remember_digest",     limit: 255
    t.integer  "sign_in_count",        limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "name",                limit: 255
    t.string   "mobile",              limit: 255
    t.boolean  "mobile_verified",      default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["mobile"], name: "index_users_on_mobile", unique: true, using: :btree
  add_index "users", ["name"], name: "index_users_on_nickname", unique: true, using: :btree
  end
end
