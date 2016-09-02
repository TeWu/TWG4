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
    photo_in_albums.build photo: photo, display_order: display_order_for_new_photo
  end


  def display_order_for_new_photo
    (display_order_of_last_photo || 0) + 1
  end

  def display_order_of_last_photo
    photo_in_albums.maximum(:display_order)
  end


  def prev_photo_id(current_photo)
    neighbour_photo_id current_photo, true
  end

  def next_photo_id(current_photo)
    neighbour_photo_id current_photo, false
  end

  def neighbour_photo_id(current_photo, is_prev)
    rel, sort_order = is_prev ? ['<', 'DESC'] : ['>', 'ASC']
    current_display_order = current_photo.photo_in_albums.find_by(album: self).display_order
    PhotoInAlbum.where(["album_id = ? AND display_order #{rel} ?", id, current_display_order])
        .order("display_order #{sort_order}")
        .limit(1).pluck(:photo_id).first
  end

  def page_count
    photos.page(1).total_pages
  end

  def page_with(photo)
    photo ? photo.photo_in_albums.find_by(album: self).page : nil
  end

end
