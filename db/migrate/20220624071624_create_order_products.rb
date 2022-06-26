class CreateOrderProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :order_products do |t|
      # t.integer :product_id
      t.references :product, null: false, foreign_key: {on_delete: :cascade}
      # t.integer :order_id
      t.references :order, null: false, foreign_key: {on_delete: :cascade}
      t.integer :quantity
      t.index [:id, :order_id], unique: true
      # t.index [:product_id]

      t.timestamps
    end
  end
end
