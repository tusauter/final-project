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

ActiveRecord::Schema.define(version: 20190830192701) do

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.integer "resource_id"
    t.string "author_type"
    t.integer "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "apartment_follows", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "apartment_id", null: false
    t.integer "year", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "soft_deleted_at"
    t.index ["apartment_id"], name: "apartment_follows_apartment_idx"
    t.index ["user_id"], name: "apartment_follows_user_idx"
  end

  create_table "apartments", force: :cascade do |t|
    t.text "address", null: false
    t.text "apartment_number"
    t.text "city", null: false
    t.text "state", null: false
    t.text "zip", null: false
    t.text "country"
    t.float "longitude", null: false
    t.float "latitude", null: false
    t.integer "square_feet"
    t.integer "total_rooms"
    t.boolean "in_unit_washer_dryer"
    t.boolean "building_has_laundry"
    t.integer "floor_of_building"
    t.boolean "building_has_gym"
    t.boolean "building_has_pool"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "soft_deleted_at"
    t.index ["address", "apartment_number", "city", "state"], name: "apartments_address_apartment_number_city_state_key"
  end

  create_table "current_locations", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "year", null: false
    t.integer "apartment_id"
    t.float "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "soft_deleted_at"
    t.index ["apartment_id"], name: "current_locations_apartment_idx"
    t.index ["user_id"], name: "current_locations_user_idx"
  end

  create_table "destinations", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "year", null: false
    t.text "city"
    t.text "state"
    t.text "country"
    t.float "longitude"
    t.float "latitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "soft_deleted_at"
    t.index ["user_id"], name: "destinations_user_idx"
  end

  create_table "room_follows", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "room_id", null: false
    t.integer "year", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "soft_deleted_at"
    t.index ["room_id"], name: "room_follows_room_idx"
    t.index ["user_id"], name: "room_follows_user_idx"
  end

  create_table "room_statuses", force: :cascade do |t|
    t.integer "room_id", null: false
    t.integer "year", null: false
    t.integer "owner_id", null: false
    t.text "gender_preference"
    t.boolean "available_for_sublet"
    t.integer "sublettor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "soft_deleted_at"
    t.index ["owner_id"], name: "room_statuses_owner_idx"
    t.index ["room_id"], name: "room_statuses_room_idx"
    t.index ["sublettor_id"], name: "room_statuses_sublettor_idx"
  end

  create_table "rooms", force: :cascade do |t|
    t.integer "apartment_id", null: false
    t.boolean "has_own_bathroom"
    t.boolean "has_walkin_closet"
    t.integer "room_square_feet"
    t.integer "asking_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "soft_deleted_at"
    t.index ["apartment_id"], name: "rooms_apartment_idx"
  end

  create_table "user_statuses", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "year", null: false
    t.text "destination"
    t.boolean "found_sublettor"
    t.boolean "found_room_near_destination"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "soft_deleted_at"
    t.index ["user_id"], name: "user_statuses_user_idx"
  end

  create_table "users", force: :cascade do |t|
    t.text "email", null: false
    t.text "first_name", null: false
    t.text "last_name", null: false
    t.text "gender"
    t.text "salt", null: false
    t.text "password_hash", null: false
    t.text "activation_token"
    t.datetime "activation_expiry"
    t.boolean "account_activated", default: false, null: false
    t.text "password_reset_token"
    t.datetime "password_reset_expiry"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "soft_deleted_at"
  end

end
