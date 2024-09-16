class Make < ApplicationRecord
  has_many :models
  belongs_to :country
end
