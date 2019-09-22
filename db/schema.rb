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

ActiveRecord::Schema.define(version: 2019_09_19_125459) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "board_pinners", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "board_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["board_id"], name: "index_board_pinners_on_board_id"
    t.index ["user_id"], name: "index_board_pinners_on_user_id"
  end

  create_table "boards", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_boards_on_user_id"
  end

  create_table "categories", id: :serial, force: :cascade do |t|
    t.string "name"
  end

  create_table "followers", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "follower_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["follower_id"], name: "index_followers_on_follower_id"
    t.index ["user_id"], name: "index_followers_on_user_id"
  end

  create_table "pinnings", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "pin_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "board_id"
    t.index ["board_id"], name: "index_pinnings_on_board_id"
    t.index ["pin_id"], name: "index_pinnings_on_pin_id"
    t.index ["user_id"], name: "index_pinnings_on_user_id"
  end

  create_table "pins", id: :serial, force: :cascade do |t|
    t.string "title"
    t.string "url"
    t.text "text"
    t.string "slug"
    t.integer "category_id"
    t.string "image_file_name"
    t.string "image_content_type"
    t.bigint "image_file_size"
    t.datetime "image_updated_at"
    t.bigint "user_id"
    t.index ["category_id"], name: "index_pins_on_category_id"
    t.index ["user_id"], name: "index_pins_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
  end

  add_foreign_key "board_pinners", "boards"
  add_foreign_key "board_pinners", "users"
  add_foreign_key "boards", "users"
  add_foreign_key "followers", "users"
  add_foreign_key "followers", "users", column: "follower_id"
  add_foreign_key "pinnings", "pins"
  add_foreign_key "pinnings", "users"
  add_foreign_key "pins", "users"
end
