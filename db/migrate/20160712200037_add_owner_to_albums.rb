class AddOwnerToAlbums < ActiveRecord::Migration[5.0]
  def self.up
    add_reference :albums, :owner,
                  null: true, # because there is "dependent: :nullify" in User model
                  index: true,
                  foreign_key: {to_table: :users} # This can't be reverted automatically
  end

  def self.down
    remove_foreign_key :albums, column: :owner_id
    remove_column :albums, :owner_id
  end
end
