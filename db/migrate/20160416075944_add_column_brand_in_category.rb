class AddColumnBrandInCategory < ActiveRecord::Migration
  def change
  	add_column :categories, :brand, :string
  end
end
