class Photo < ApplicationRecord
  has_many :photo_in_albums, dependent: :destroy
  has_many :albums, through: :photo_in_albums
  has_many :comments

  validates :path, presence: true, uniqueness: true, length: {maximum: 512}
  validates :description, allow_nil: true, length: {maximum: 1_000}


  def save_and_add_to_album(album)
    convert_exception_to_boolean do
      transaction do
        save!
        album.add_photo! self
      end
    end
  end

end
