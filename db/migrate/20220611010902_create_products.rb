# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name
      t.string :description
      t.string :image
      t.integer :price
      t.float :rating, default: 0.0
      t.integer :category_id
      t.integer :store_id

      t.timestamps
    end
  end
end
