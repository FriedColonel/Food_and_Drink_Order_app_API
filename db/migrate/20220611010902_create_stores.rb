class CreateStores < ActiveRecord::Migration[6.1]
  def change
    create_table :stores do |t|
      t.string :store_name
      t.string :store_address
      t.string :password_digest
      t.string :email
      # t.index :email

      t.timestamps
    end
  end
end
