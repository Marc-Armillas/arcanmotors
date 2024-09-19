class CreateInitialSchema < ActiveRecord::Migration[7.2]
  def change
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
      t.boolean "four_wheel_drive"
      t.string "exterior_color"
      t.string "manufacturer_color_name"
      t.integer "doors"
      t.integer "seats"
      t.string "interior_color"
      t.string "interior_material"
      t.string "vin"
      t.decimal "consumption_city"
      t.decimal "consumption_suburban"
      t.decimal "consumption_highway"
      t.decimal "consumption_combined"
      t.decimal "base_price"
      t.decimal "tax"
      t.decimal "total_price"
      t.integer 'transmission'
      t.index ["category_id"], name: "index_cars_on_category_id"
      t.index ["emission_sticker_id"], name: "index_cars_on_emission_sticker"
      t.index ["make_id"], name: "index_cars_on_make_id"
      t.boolean 'in_home_page', default: false
    end

    create_table "categories", force: :cascade do |t|
      t.string "name"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
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

    add_foreign_key "cars", "categories"
    add_foreign_key "cars", "emission_stickers", column: "emission_sticker_id"
    add_foreign_key "makes", "countries"
  end
end
