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

ActiveRecord::Schema.define(version: 20160910073503) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "albums", force: :cascade do |t|
    t.string   "name",            null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "owner_id"
    t.string   "special_purpose"
    t.index ["name"], name: "index_albums_on_name", unique: true, using: :btree
    t.index ["owner_id"], name: "index_albums_on_owner_id", using: :btree
    t.index ["special_purpose"], name: "index_albums_on_special_purpose", unique: true, using: :btree
  end

  create_table "comments", force: :cascade do |t|
    t.text     "content",    null: false
    t.integer  "author_id"
    t.integer  "photo_id",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_comments_on_author_id", using: :btree
    t.index ["photo_id"], name: "index_comments_on_photo_id", using: :btree
  end

  create_table "photos", force: :cascade do |t|
    t.string   "image",       null: false
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "owner_id"
    t.index ["image"], name: "index_photos_on_image", unique: true, using: :btree
    t.index ["owner_id"], name: "index_photos_on_owner_id", using: :btree
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

  create_table "users", force: :cascade do |t|
    t.string   "display_name",             null: false
    t.string   "username",                 null: false
    t.string   "passhash",      limit: 96, null: false
    t.integer  "roles_bitmask"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["display_name"], name: "index_users_on_display_name", unique: true, using: :btree
    t.index ["username"], name: "index_users_on_username", unique: true, using: :btree
  end

  add_foreign_key "albums", "users", column: "owner_id"
  add_foreign_key "comments", "photos"
  add_foreign_key "comments", "users", column: "author_id"
  add_foreign_key "photos", "users", column: "owner_id"
  add_foreign_key "photos_in_albums", "albums"
  add_foreign_key "photos_in_albums", "photos"
end
