class CarsController < ApplicationController
  def index
    @cars = Car.with_attached_images
  end

  def show
    @car = Car.find(get_car_id)
  end
end
