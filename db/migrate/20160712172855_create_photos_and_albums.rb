class CreatePhotosAndAlbums < ActiveRecord::Migration[5.0]
  def change
    create_table :photos do |t|
      t.string :path, null: false
      t.string :description
      t.timestamps
    end
    add_index :photos, :path, unique: true

    create_table :albums do |t|
      t.string :name, null: false
      t.timestamps
    end
    add_index :albums, :name, unique: true

    create_table :photos_in_albums do |t|
      t.references :photo, null: false, index: true, foreign_key: true
      t.references :album, null: false, index: true, foreign_key: true
      t.integer :display_order, null: false
      t.timestamps
    end
    add_index :photos_in_albums, [:photo_id, :album_id, :display_order], unique: true, name: 'photos_in_albums_ordering'
  end
end
