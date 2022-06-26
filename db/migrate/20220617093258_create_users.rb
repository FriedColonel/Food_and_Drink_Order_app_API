class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :username, null: false
      t.string :password_digest
      t.string :address
      # t.string :role, enum: {admin: 'manager', user: 'customer'}, default: 'customer'
      t.boolean :admin, default: 'false'
      t.string :email
      t.string :phone_number, unique: true
      t.string :image, default: 'https://i.stack.imgur.com/l60Hf.png'
      # t.index [:id, :email]

      t.timestamps
    end
  end
end
