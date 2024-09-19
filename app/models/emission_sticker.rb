class EmissionSticker < ApplicationRecord
  has_many :cars
  has_one_attached :image

  validates :name, presence: true
  validates :name, uniqueness: true
end
