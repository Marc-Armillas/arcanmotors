class CarsController < ApplicationController
  def index
    cars = Car.published.with_attached_images.includes(:make, :category)
    @categories = Category.where(id: cars.select(:category_id)).order(:name)
    @current_category = @categories.find { |category| category.name.parameterize == params[:categoria] }
    cars = cars.where(category: @current_category) if @current_category
    @cars = cars.order(:status, created_at: :desc)
    @model_lines = ModelLine.with_stock
  end

  def show
    @car = Car.with_attached_images.includes(:make, :category).find(get_car_id)
    redirect_to car_path(@car), status: :moved_permanently if params[:id] != @car.to_param
  end
end
