class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string "avatar"
      t.string "location"
      t.string "gender"
      t.string "city"
      t.text "description"
      t.integer "age"
      t.integer "user_id"
      t.date "birthday"
      t.timestamps null: false
    end
  end
end
