class PhotoInAlbum < ApplicationRecord
  self.table_name = 'photos_in_albums'
  belongs_to :photo, inverse_of: :photo_in_albums
  belongs_to :album, inverse_of: :photo_in_albums

  validates :photo, :album, presence: true
  validates :display_order, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}


  def self.get(album, photo)
    PhotoInAlbum.find_by(album_id: album.id, photo_id: photo.id)
  end
end
