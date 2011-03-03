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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110303201615) do

  create_table "addresses", :force => true do |t|
    t.string  "name"
    t.string  "building_name"
    t.string  "address"
    t.string  "city"
    t.string  "state"
    t.string  "zip"
    t.boolean "in_district"
    t.point   "the_geom",      :limit => nil, :srid => 4326
    t.integer "provider_id"
  end

  add_index "addresses", ["the_geom"], :name => "index_addresses_on_the_geom", :spatial => true

  create_table "clients", :force => true do |t|
    t.string  "first_name"
    t.string  "middle_initial"
    t.string  "last_name"
    t.string  "phone_number_1"
    t.string  "phone_number_2"
    t.integer "address_id"
    t.string  "email"
    t.date    "activated_date"
    t.date    "inactivated_date"
    t.string  "inactivated_reason"
    t.date    "birth_date"
    t.integer "mobility_id"
    t.string  "mobility_notes"
    t.string  "ethnicity"
    t.string  "emergency_contact_notes"
    t.string  "private_notes"
    t.string  "public_notes"
    t.integer "provider_id"
  end

  create_table "drivers", :force => true do |t|
    t.string  "first_name"
    t.string  "last_name"
    t.boolean "active"
    t.boolean "paid"
    t.integer "provider_id"
  end

  create_table "funding_sources", :force => true do |t|
    t.string "name"
  end

  create_table "mobilities", :force => true do |t|
    t.string "name"
  end

  create_table "monthlies", :force => true do |t|
    t.date    "start_date"
    t.date    "end_date"
    t.integer "volunteer_escort_hours"
    t.integer "volunteer_admin_hours"
  end

  create_table "providers", :force => true do |t|
    t.string "name"
  end

  create_table "regions", :force => true do |t|
    t.string  "name"
    t.polygon "the_geom", :limit => nil, :srid => 4326
  end

  add_index "regions", ["the_geom"], :name => "index_regions_on_the_geom", :spatial => true

  create_table "roles", :force => true do |t|
    t.integer "user_id"
    t.integer "provider_id"
    t.boolean "admin"
  end

  create_table "runs", :force => true do |t|
    t.string   "name"
    t.date     "date"
    t.integer  "start_odometer"
    t.integer  "end_odometer"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "unpaid_driver_break_time"
    t.integer  "vehicle_id"
    t.integer  "driver_id"
    t.boolean  "paid"
    t.boolean  "complete"
    t.integer  "provider_id"
  end

  create_table "trips", :force => true do |t|
    t.integer  "run_id"
    t.integer  "client_id"
    t.datetime "pickup_time"
    t.datetime "appointment_time"
    t.integer  "guest_count"
    t.integer  "attendant_count"
    t.integer  "group_size"
    t.integer  "pickup_address_id"
    t.integer  "dropoff_address_id"
    t.integer  "mobility_id"
    t.integer  "funding_source_id"
    t.string   "trip_purpose"
    t.string   "trip_result"
    t.string   "notes"
    t.decimal  "donation",           :precision => 10, :scale => 2
    t.datetime "trip_confirmed"
    t.integer  "provider_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "current_provider_id"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "vehicles", :force => true do |t|
    t.string  "name"
    t.integer "year"
    t.string  "make"
    t.string  "model"
    t.string  "license_plate"
    t.string  "vin"
    t.string  "garaged_location"
    t.integer "provider_id"
  end

end