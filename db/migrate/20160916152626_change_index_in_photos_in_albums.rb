class ChangeIndexInPhotosInAlbums < ActiveRecord::Migration[5.0]
  def change
    remove_index :photos_in_albums, name: 'photos_in_albums_ordering'
    add_index :photos_in_albums, [:photo_id, :album_id], unique: true
  end
end
