class Comment < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :photo

  validates :content, presence: true, length: {maximum: 1_000}
  validates :author, presence: true, on: :create
  validates :photo, presence: true
end
