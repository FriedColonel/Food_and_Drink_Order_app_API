# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name
      t.string :description
      t.string :image
      t.integer :price
      t.float :rating, default: 0.0
      t.references :store, null: false, foreign_key: {on_delete: :cascade}
      t.references :category, null: false, foreign_key: true
      # t.index :category_id
      # t.index [:category_id, :store_id]

      t.timestamps
    end
  end
end
