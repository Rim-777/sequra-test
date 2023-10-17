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

ActiveRecord::Schema[7.0].define(version: 2023_10_07_155738) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "disbursement_frequency", ["WEEKLY", "DAILY"]

  create_table "disbursements", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.decimal "fee", precision: 10, scale: 2, null: false
    t.decimal "monthly_fee", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "perform_datetime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "merchant_orders", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "merchant_id"
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["merchant_id"], name: "index_merchant_orders_on_merchant_id"
  end

  create_table "merchant_orders_disbursements", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "merchant_order_id"
    t.uuid "disbursement_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["disbursement_id"], name: "index_merchant_orders_disbursements_on_disbursement_id"
    t.index ["merchant_order_id", "disbursement_id"], name: "index_orders_disbursements_on_order_id_and_disbursement_id", unique: true
    t.index ["merchant_order_id"], name: "index_merchant_orders_disbursements_on_merchant_order_id"
  end

  create_table "merchants", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", null: false
    t.datetime "started_at", null: false
    t.enum "disbursement_frequency", null: false, enum_type: "disbursement_frequency"
    t.decimal "minimum_monthly_fee", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_merchants_on_email", unique: true
    t.index ["started_at"], name: "index_merchants_on_started_at"
  end

  add_foreign_key "merchant_orders", "merchants"
  add_foreign_key "merchant_orders_disbursements", "disbursements"
  add_foreign_key "merchant_orders_disbursements", "merchant_orders"
end
