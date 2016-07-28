class Album < ApplicationRecord
  belongs_to :owner, class_name: 'User', inverse_of: :owned_albums
  has_many :photo_in_albums, dependent: :destroy
  has_many :photos, through: :photo_in_albums

  validates :name, presence: true, uniqueness: true, length: {within: 3..45}
  validates :owner, presence: true, on: :create


  def ordered_photos
    pia = PhotoInAlbum.table_name
    Photo.joins(:photo_in_albums).where(pia => {album_id: id}).order("#{pia}.display_order ASC")
  end

  def build_photo_in_album(photo)
    photo_in_albums.build photo: photo, display_order: position_to_add_photo
  end


  def position_to_add_photo
    (position_of_last_photo || 0) + 1
  end

  def position_of_last_photo
    photo_in_albums.maximum(:display_order)
  end

end
