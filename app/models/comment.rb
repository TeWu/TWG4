class Comment < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :photo

  validates :content, presence: true, length: {maximum: 1000}
  validates :author, presence: true, on: :create
  validates :photo, presence: true

  before_validation { self.content = content.strip }


  def max_length
    Comment.max_length(:content)
  end
end
