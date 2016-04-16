class CreateAwsProductLookups < ActiveRecord::Migration
  def change
    create_table :aws_product_lookups do |t|
      t.string :product_id
      t.integer :category_id

      t.timestamps null: false
    end
  end
end
