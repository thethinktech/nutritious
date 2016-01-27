class Category < ActiveRecord::Base
  validates_presence_of :name, :search_index, :keyword
end
