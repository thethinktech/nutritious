class CreateTestimonials < ActiveRecord::Migration
  def change
    create_table :testimonials do |t|
      t.integer :user_id
      t.text :content
      t.string :name
      t.string :image
      t.string :city
      t.string :country

      t.timestamps null: false
    end
  end
end
