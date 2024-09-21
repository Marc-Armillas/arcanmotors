class Country < ApplicationRecord
  has_many :makes
  has_many :cars
end
