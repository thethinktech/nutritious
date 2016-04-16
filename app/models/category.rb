class Category < ActiveRecord::Base
  validates_presence_of :name, :search_index, :keyword
  has_many :aws_product_lookups
end
