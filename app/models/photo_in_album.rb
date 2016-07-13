class PhotoInAlbum < ApplicationRecord
  self.table_name = 'photos_in_albums'
  belongs_to :photo
  belongs_to :album

  validates :photo, :album, presence: true
  validates :display_order, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
end
