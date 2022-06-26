class CreateRatings < ActiveRecord::Migration[6.1]
  def change
    create_table :ratings do |t|
      # t.integer :user_id
      t.references :user, null: false, foreign_key: {on_delete: :cascade}
      # t.integer :product_id
      t.references :product, null: false, foreign_key: {on_delete: :cascade}
      t.integer :vote
      t.text :comment

      t.timestamps
    end
  end
end
