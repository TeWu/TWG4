class Photo < ApplicationRecord
  has_many :photo_in_albums, dependent: :destroy
  has_many :albums, through: :photo_in_albums
end
