class Photo < ApplicationRecord
  has_many :photo_in_albums, dependent: :destroy
  has_many :albums, through: :photo_in_albums
  has_many :comments

  validates :image, presence: true
  validates :description, allow_nil: true, length: {maximum: 1_000}

  mount_uploader :image, PhotoUploader


  def save_and_add_to_album(album)
    convert_exception_to_boolean do
      transaction do
        save!
        album.add_photo! self
      end
    end
  end

end
