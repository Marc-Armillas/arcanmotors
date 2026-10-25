# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2026_10_24_190100) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "cars", force: :cascade do |t|
    t.decimal "price"
    t.string "name"
    t.text "description"
    t.integer "year"
    t.integer "kilometers"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "category_id"
    t.bigint "make_id"
    t.bigint "emission_sticker_id"
    t.bigint "origin_country_id"
    t.integer "condition"
    t.date "first_registration"
    t.date "next_inspection"
    t.string "model_description"
    t.string "model"
    t.decimal "cubic_capacity"
    t.integer "power"
    t.integer "previous_owners"
    t.integer "cv"
    t.integer "gearbox"
    t.integer "fuel"
    t.string "exterior_color"
    t.string "manufacturer_color_name"
    t.integer "doors"
    t.integer "seats"
    t.string "interior_color"
    t.string "interior_material"
    t.string "vin"
    t.decimal "consumption_city"
    t.decimal "consumption_highway"
    t.decimal "consumption_combined"
    t.decimal "base_price"
    t.decimal "tax"
    t.decimal "total_price"
    t.integer "transmission"
    t.boolean "in_home_page", default: false
    t.integer "status", default: 0
    t.boolean "is_public", default: true
    t.index ["category_id"], name: "index_cars_on_category_id"
    t.index ["emission_sticker_id"], name: "index_cars_on_emission_sticker"
    t.index ["make_id"], name: "index_cars_on_make_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contact_requests", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.string "subject"
    t.text "message"
    t.boolean "viewed", default: false
    t.bigint "car_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_id"], name: "index_contact_requests_on_car_id"
  end

  create_table "countries", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_eu"
  end

  create_table "emission_stickers", force: :cascade do |t|
    t.string "name"
    t.string "emission_class"
    t.decimal "co2_emission"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "makes", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "country_id", null: false
    t.index ["country_id"], name: "index_makes_on_country_id"
  end

  create_table "sell_requests", force: :cascade do |t|
    t.string "name", null: false
    t.string "email"
    t.string "phone"
    t.string "model", null: false
    t.integer "year"
    t.integer "kilometers"
    t.integer "asking_price"
    t.text "notes"
    t.boolean "handled", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stock_alerts", force: :cascade do |t|
    t.string "name", null: false
    t.string "email"
    t.string "phone"
    t.string "model_line"
    t.integer "max_price"
    t.text "notes"
    t.boolean "handled", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "cars", "categories"
  add_foreign_key "cars", "countries", column: "origin_country_id"
  add_foreign_key "cars", "emission_stickers"
  add_foreign_key "cars", "makes"
  add_foreign_key "contact_requests", "cars"
  add_foreign_key "makes", "countries"
end
