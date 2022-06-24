class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.integer :user_id
      t.string :receiver_name
      t.string :receiver_phone
      t.integer :status, default: 0
      t.float :total

      t.timestamps
    end
  end
end
