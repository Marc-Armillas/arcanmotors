class GuidesController < ApplicationController
  def index
    @guides = Guide.visible(admin: admin?)
  end

  def show
    @guide = Guide.find(params[:slug], admin: admin?) or raise ActionController::RoutingError, "Guía no encontrada"
    @line = ModelLine.find(@guide.model_line) if @guide.model_line
    @cars = @line ? ModelLine.cars(@line, Car.published).with_attached_images.includes(:make).limit(2) : Car.published.with_attached_images.includes(:make).order(id: :desc).limit(2)
  end

  private

  def admin?
    current_user&.admin?
  end
end
