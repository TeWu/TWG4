class Photo < ApplicationRecord
  has_many :photo_in_albums, dependent: :destroy
  has_many :albums, through: :photo_in_albums
  has_many :comments, dependent: :destroy

  validates :image, presence: true
  validates :description, allow_nil: true, length: {maximum: 1_000}

  mount_uploader :image, PhotoUploader

  paginates_per 5


  def image_url(version = :default)
    return image.thumbnail.url if version == :thumbnail and image.thumbnail.file.exists?
    return image.medium.url if version.in? %i[ medium thumbnail ] and image.medium.file.exists?
    image.url
  end

end
