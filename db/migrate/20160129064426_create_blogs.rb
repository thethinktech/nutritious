class CreateBlogs < ActiveRecord::Migration
  def change
    create_table :blogs do |t|
      t.string :title
      t.text :decsription
      t.string :image
      t.integer :user_id
      t.integer :category_id

      t.timestamps null: false
    end
  end
end
