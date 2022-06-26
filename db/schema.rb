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

ActiveRecord::Schema.define(version: 2022_07_23_053033) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name"
  end

  create_table "order_products", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "order_id", null: false
    t.integer "quantity"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["id", "order_id"], name: "index_order_products_on_id_and_order_id", unique: true
    t.index ["order_id"], name: "index_order_products_on_order_id"
    t.index ["product_id"], name: "index_order_products_on_product_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "receiver_name"
    t.string "receiver_phone"
    t.integer "status", default: 0
    t.float "total", default: 0.0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "image"
    t.integer "price"
    t.float "rating", default: 0.0
    t.bigint "store_id", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["store_id"], name: "index_products_on_store_id"
  end

  create_table "ratings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "product_id", null: false
    t.integer "vote"
    t.text "comment"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_ratings_on_product_id"
    t.index ["user_id"], name: "index_ratings_on_user_id"
  end

  create_table "stores", force: :cascade do |t|
    t.string "store_name"
    t.string "store_address"
    t.string "password_digest"
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "image"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "username", null: false
    t.string "password_digest"
    t.string "address"
    t.boolean "admin", default: false
    t.string "email"
    t.string "phone_number"
    t.string "image", default: "https://i.stack.imgur.com/l60Hf.png"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "order_products", "orders", on_delete: :cascade
  add_foreign_key "order_products", "products", on_delete: :cascade
  add_foreign_key "orders", "users", on_delete: :cascade
  add_foreign_key "products", "categories"
  add_foreign_key "products", "stores", on_delete: :cascade
  add_foreign_key "ratings", "products", on_delete: :cascade
  add_foreign_key "ratings", "users", on_delete: :cascade
  create_trigger("ratings_after_insert_update_row_tr", :generated => true, :compatibility => 1).
      on("ratings").
      after(:insert, :update) do
    <<-SQL_ACTIONS
      UPDATE products
      SET rating = (SELECT AVG(vote) FROM ratings WHERE product_id = NEW.product_id)
      WHERE id = NEW.product_id;
    SQL_ACTIONS
  end

  create_trigger("ratings_after_delete_row_tr", :generated => true, :compatibility => 1).
      on("ratings").
      after(:delete) do
    <<-SQL_ACTIONS
    UPDATE products
    SET rating = (SELECT AVG(vote) FROM ratings WHERE product_id = OLD.product_id)
    WHERE id = OLD.product_id;
    SQL_ACTIONS
  end

  create_trigger("order_products_after_delete_row_tr", :generated => true, :compatibility => 1).
      on("order_products").
      after(:delete) do
    <<-SQL_ACTIONS
      WITH total_cost AS (
        SELECT SUM(products.price * order_products.quantity) AS "cost" FROM order_products
        JOIN products ON order_products.product_id = products.id
        WHERE order_products.order_id = OLD.order_id
      )
      UPDATE orders
      SET total = (SELECT * FROM total_cost)
      WHERE id = OLD.order_id;
    SQL_ACTIONS
  end

  create_trigger("order_products_after_insert_update_row_tr", :generated => true, :compatibility => 1).
      on("order_products").
      after(:insert, :update) do
    <<-SQL_ACTIONS
      WITH total_cost AS (
        SELECT SUM(products.price * order_products.quantity) AS "cost" FROM order_products
        JOIN products ON order_products.product_id = products.id
        WHERE order_products.order_id = NEW.order_id
      )
      UPDATE orders
      SET total = (SELECT * FROM total_cost)
      WHERE id = NEW.order_id;
    SQL_ACTIONS
  end

end
