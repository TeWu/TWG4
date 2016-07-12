class Album < ApplicationRecord
  has_many :photo_in_albums, dependent: :destroy
  has_many :photos, through: :photo_in_albums
end
