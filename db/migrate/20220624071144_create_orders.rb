class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      # t.integer :user_id
      t.references :user, null: false, foreign_key: {on_delete: :cascade}
      t.string :receiver_name
      t.string :receiver_phone
      t.integer :status, default: 0
      t.float :total, default: 0.0
      # t.index :user_id

      t.timestamps
    end
  end
end
