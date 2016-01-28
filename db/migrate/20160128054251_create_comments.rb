class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :name
      t.string :email
      t.text :message
      t.integer :blog_id
      t.integer :parent_id

      t.timestamps null: false
    end
  end
end
