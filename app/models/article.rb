class Article < ActiveRecord::Base


  belongs_to :writer, foreign_key: "original_author_id",class_name: "User"
  belongs_to :category
  validates :original_author_id,presence: true
  validates :title, presence: true
end
