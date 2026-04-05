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

ActiveRecord::Schema[8.1].define(version: 2026_04_03_090100) do
  create_schema "extensions"

  # These are extensions that must be enabled in order to support this database
  enable_extension "extensions.pg_stat_statements"
  enable_extension "extensions.pgcrypto"
  enable_extension "extensions.uuid-ossp"
  enable_extension "graphql.pg_graphql"
  enable_extension "pg_catalog.plpgsql"
  enable_extension "vault.supabase_vault"

  create_table "public.carts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "shop_id", null: false
    t.string "telegram_user_id"
    t.datetime "updated_at", null: false
    t.index ["shop_id"], name: "index_carts_on_shop_id"
  end

  create_table "public.categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.bigint "shop_id", null: false
    t.datetime "updated_at", null: false
    t.index ["shop_id"], name: "index_categories_on_shop_id"
  end

  create_table "public.orders", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "payment_reference"
    t.bigint "shop_id", null: false
    t.string "status"
    t.string "telegram_user_id"
    t.decimal "total_price"
    t.datetime "updated_at", null: false
    t.index ["shop_id"], name: "index_orders_on_shop_id"
  end

  create_table "public.products", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.bigint "category_id"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.decimal "price", precision: 12, scale: 2, default: "0.0", null: false
    t.bigint "shop_id", null: false
    t.string "sku"
    t.integer "stock_quantity", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["shop_id"], name: "index_products_on_shop_id"
    t.index ["sku"], name: "index_products_on_sku", unique: true
  end

  create_table "public.shops", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.string "currency", default: "ETB", null: false
    t.text "description"
    t.string "name", null: false
    t.string "slug"
    t.string "subdomain"
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_shops_on_slug", unique: true
    t.index ["subdomain"], name: "index_shops_on_subdomain", unique: true
  end

  create_table "public.users", force: :cascade do |t|
    t.boolean "allow_password_change", default: false
    t.datetime "confirmation_sent_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "encrypted_password", default: "", null: false
    t.string "language", default: "en", null: false
    t.string "name"
    t.string "provider", default: "email", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.string "telegram_id"
    t.json "tokens"
    t.string "uid", default: "", null: false
    t.string "unconfirmed_email"
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["telegram_id"], name: "index_users_on_telegram_id", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  add_foreign_key "public.carts", "public.shops"
  add_foreign_key "public.categories", "public.shops"
  add_foreign_key "public.orders", "public.shops"
  add_foreign_key "public.products", "public.categories"
  add_foreign_key "public.products", "public.shops"

end
