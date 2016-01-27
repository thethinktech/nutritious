class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.string :search_index
      t.string :keyword
      t.integer :parent_id

      t.timestamps null: false
    end
  end
end
