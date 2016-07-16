class RenamePhotoPathToImage < ActiveRecord::Migration[5.0]
  def change
    rename_column :photos, :path, :image
  end
end
