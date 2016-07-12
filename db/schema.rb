# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160712172855) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "albums", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_albums_on_name", unique: true, using: :btree
  end

  create_table "photos", force: :cascade do |t|
    t.string   "path",        null: false
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["path"], name: "index_photos_on_path", unique: true, using: :btree
  end

  create_table "photos_in_albums", force: :cascade do |t|
    t.integer  "photo_id",      null: false
    t.integer  "album_id",      null: false
    t.integer  "display_order", null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["album_id"], name: "index_photos_in_albums_on_album_id", using: :btree
    t.index ["photo_id", "album_id", "display_order"], name: "photos_in_albums_ordering", unique: true, using: :btree
    t.index ["photo_id"], name: "index_photos_in_albums_on_photo_id", using: :btree
  end

  add_foreign_key "photos_in_albums", "albums"
  add_foreign_key "photos_in_albums", "photos"
end
