class CarsController < ApplicationController
  def index
    @cars = Car.with_attached_images
  end

  def show
    @car = Car.find(params[:id])
  end
end
