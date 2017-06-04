class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string "filename"
      t.integer "user_id"
      t.string "hash"
      t.timestamps null: false
    end
  end
end
