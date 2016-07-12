class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :display_name, null: false
      t.string :username, null: false
      t.string :passhash, null: false, limit: 96
      t.integer :roles_bitmask, null: false, default: 0
      t.timestamps
    end
    add_index :users, :display_name, unique: true
    add_index :users, :username, unique: true
  end
end
