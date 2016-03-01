class CreateCarts < ActiveRecord::Migration
  def change
    create_table :carts do |t|
      t.integer :user_id
      t.string :cart_id
      t.string :hmac
      t.string :purchase_url
      t.integer :quantity
      t.string :price
      t.string :cart_item_id
      t.string :title

      t.timestamps null: false
    end
  end
end
