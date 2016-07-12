class Album < ApplicationRecord
  belongs_to :owner, class_name: 'User', inverse_of: :owned_albums
  has_many :photo_in_albums, dependent: :destroy
  has_many :photos, through: :photo_in_albums
end
