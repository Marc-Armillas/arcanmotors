class StockAlertsController < ApplicationController
  def new
    @stock_alert = StockAlert.new(model_line: params[:modelo])
  end

  def create
    @stock_alert = StockAlert.new(stock_alert_params)

    if @stock_alert.spam? || @stock_alert.save
      flash[:success] = "Listo. Te avisaremos en cuanto entre un Porsche que encaje con lo que buscas."
      redirect_back fallback_location: cars_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def stock_alert_params
    params.require(:stock_alert).permit(:name, :email, :phone, :model_line, :max_price, :notes, :privacy_accepted, :website)
  end
end
