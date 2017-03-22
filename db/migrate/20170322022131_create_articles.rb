class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.integer "user_id"
      t.integer "original_author_id"
      t.text "content"
      t.text "title"
      t.boolean  "published"
      t.string "cover"
      t.integer "category_id"
      t.integer "replies_count"
      t.integer "views_count"

      t.timestamps null: false
    end
  end
end
