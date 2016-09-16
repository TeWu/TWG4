class PhotoInAlbum < ApplicationRecord
  self.table_name = 'photos_in_albums'
  belongs_to :photo, inverse_of: :photo_in_albums
  belongs_to :album, inverse_of: :photo_in_albums

  validates :photo, :album, presence: true
  validates :photo, uniqueness: {scope: :album, message: "is already in this album"}
  validates :display_order, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}


  def self.get(album, photo)
    PhotoInAlbum.find_by(album_id: album.id, photo_id: photo.id)
  end


  def position
    @position ||= 1 + PhotoInAlbum.where(["album_id = ? AND display_order < ?", album_id, display_order]).count
  end

  def page
    @page ||= (position / Photo.default_per_page.to_f).ceil
  end

end
