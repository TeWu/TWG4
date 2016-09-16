class AddIndexToPhotosInAlbumsDisplayOrder < ActiveRecord::Migration[5.0]
  def change
    add_index :photos_in_albums, :display_order
    add_index :photos_in_albums, [:album_id, :display_order], unique: true
  end
end
