class Photo < ApplicationRecord
  has_many :photo_in_albums, dependent: :destroy
  has_many :albums, through: :photo_in_albums
  has_many :comments

  validates :path, presence: true, uniqueness: true, length: {maximum: 512}
  validates :description, allow_nil: true, length: {maximum: 1_000}
end
