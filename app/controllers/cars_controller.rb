class CarsController < ApplicationController
  def index
    @cars = Car.where.not(status: :sold)
  end

  def show
    @car = Car.find(get_car_id)
  end
end
