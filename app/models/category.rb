class Category < ApplicationRecord
  belongs_to :category_type
  has_and_belongs_to_many :cars
end
