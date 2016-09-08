class AddOwnerToPhotos < ActiveRecord::Migration[5.0]
  def self.up
    add_reference :photos, :owner,
                  null: true, # because there is "dependent: :nullify" in User model
                  index: true,
                  foreign_key: {to_table: :users} # This can't be reverted automatically
  end

  def self.down
    remove_foreign_key :photos, column: :owner_id
    remove_column :photos, :owner_id
  end
end
