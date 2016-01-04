class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|

      t.string :name
      t.string :email
      t.integer :phone_number
      t.text :message, null: false

      t.timestamps null: false
    end
  end
end
