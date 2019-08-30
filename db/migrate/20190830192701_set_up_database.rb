class SetUpDatabase < ActiveRecord::Migration[5.1]
  
  def change
    
    # create the users table
    create_table "users" do |t|
      t.text "email", null: false
      t.text "first_name", null: false
      t.text "last_name", null: false
      t.text "gender"
      t.text "salt", null: false
      t.text "password_hash", null: false
      t.text "activation_token"
      t.datetime "activation_expiry"
      t.boolean "account_activated", null: false, default: false
      t.text "password_reset_token"
      t.datetime "password_reset_expiry"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.datetime "soft_deleted_at"
    end

    # now create a table specifying where the user is located
    create_table "current_locations" do |t|
      t.integer "user_id", null: false
      t.integer "year", null: false
      t.integer "apartment_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.datetime "soft_deleted_at"
      t.index ["user_id"], name: "current_locations_user_idx"
      t.index ["apartment_id"], name: "current_locations_apartment_idx"
    end

    # now create a table specifying where the users are trying to find housing
    create_table "destinations" do |t|
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

    # now create an apartments table
    create_table "apartments" do |t|
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
      t.index ["address", "apartment_number", "city", "state"], name: "apartments_address_apartment_number_city_state_key", unique: true
    end

    # now create a rooms table
    create_table "rooms" do |t|
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

    # now create an apartment follows table
    create_table "apartment_follows" do |t|
      t.integer "user_id", null: false
      t.integer "apartment_id", null: false
      t.integer "year", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.datetime "soft_deleted_at"
      t.index ["user_id"], name: "apartment_follows_user_idx"
      t.index ["apartment_id"], name: "apartment_follows_apartment_idx"
    end

    # now create a room follows table
    create_table "room_follows" do |t|
      t.integer "user_id", null: false
      t.integer "room_id", null: false
      t.integer "year", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.datetime "soft_deleted_at"
      t.index ["user_id"], name: "room_follows_user_idx"
      t.index ["room_id"], name: "room_follows_room_idx"
    end

    # now create a user status table
    create_table "user_statuses" do |t|
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

    # now create a room status table
    create_table "room_statuses" do |t|
      t.integer "room_id", null: false
      t.integer "year", null: false
      t.integer "owner_id", null: false
      t.text "gender_preference"
      t.boolean "available_for_sublet"
      t.integer "sublettor_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.datetime "soft_deleted_at"
      t.index ["room_id"], name: "room_statuses_room_idx"
      t.index ["owner_id"], name: "room_statuses_owner_idx"
      t.index ["sublettor_id"], name: "room_statuses_sublettor_idx"
    end

    # now add foreign key constraints
    add_foreign_key :apartment_follows, :apartments, column: :apartment_id, primary_key: "id", name: "apartment_follows_apartment_id_fkey"
    add_foreign_key :apartment_follows, :users, column: :user_id, primary_key: "id", name: "apartment_follows_user_id_fkey"
    add_foreign_key :destinations, :users, column: :user_id, primary_key: "id", name: "destinations_user_id_fkey"
    add_foreign_key :current_locations, :users, column: :user_id, primary_key: "id", name: "current_locations_user_id_fkey"
    add_foreign_key :current_locations, :apartments, column: :apartment_id, primary_key: "id", name: "current_locations_apartment_id_fkey"
    add_foreign_key :room_follows, :rooms, column: :room_id, primary_key: "id", name: "room_follows_room_id_fkey"
    add_foreign_key :room_follows, :users, column: :user_id, primary_key: "id", name: "room_follows_user_id_fkey"
    add_foreign_key :room_statuses, :users, column: :user_id, column: "id", primary_key: "user_id", name: "room_statuses_owner_id_fkey"
    add_foreign_key :room_statuses, :users, column: :user_id, column: "id", primary_key: "user_id", name: "room_statuses_sublettor_id_fkey"
    add_foreign_key :rooms, :apartments, column: :apartment_id, primary_key: "id", name: "rooms_apartment_id_fkey"
    add_foreign_key :user_statuses, :users, column: :user_id, primary_key: "id", name: "user_statuses_user_id_fkey"

  end

end
