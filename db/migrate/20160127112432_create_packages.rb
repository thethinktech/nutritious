class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.string :title
      t.integer :cost
      t.text :description
      t.integer :user_id

      t.timestamps null: false
    end
  end
end

