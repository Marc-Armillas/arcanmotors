class ModelLinesController < ApplicationController
  def show
    @line = ModelLine.find(params[:slug])
    @cars = ModelLine.cars(@line, Car.published).with_attached_images.includes(:make).order(:status, created_at: :desc)
    @other_lines = ModelLine.with_stock - [ @line ]
  end
end
