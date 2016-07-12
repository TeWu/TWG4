class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.text :content, null: false
      t.references :author, null: true, index: true, foreign_key: {to_table: :users}
      t.references :photo, null: false, index: true, foreign_key: true
      t.timestamps
    end
  end
end
