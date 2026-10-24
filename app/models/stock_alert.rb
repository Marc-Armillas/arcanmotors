class StockAlert < ApplicationRecord
  include LeadForm

  validates :model_line, inclusion: { in: ModelLine::SLUGS, message: "no es válido" }, allow_blank: true
  validates :max_price, numericality: { greater_than: 0, only_integer: true, message: "debe ser una cantidad en euros" }, allow_nil: true

  scope :pending, -> { where(handled: false) }

  def line
    ModelLine.find(model_line)
  end

  # Published cars that fit this request right now
  def matching_cars
    cars = Car.published
    cars = ModelLine.cars(line, cars) if line
    cars = cars.where(price: ..max_price) if max_price
    cars
  end
end
