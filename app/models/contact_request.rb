class ContactRequest < ApplicationRecord
  belongs_to :car, optional: true
end
