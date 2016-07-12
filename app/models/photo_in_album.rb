class PhotoInAlbum < ApplicationRecord
  self.table_name = 'photos_in_albums'
  belongs_to :photo
  belongs_to :album
end
