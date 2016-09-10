class AddSpecialPurposeToAlbums < ActiveRecord::Migration[5.0]
  def change
    add_column :albums, :special_purpose, :string
    add_index :albums, :special_purpose, unique: true
  end
end
