class SellRequestsController < ApplicationController
  def new
    @sell_request = SellRequest.new
  end

  def create
    @sell_request = SellRequest.new(sell_request_params)

    if @sell_request.spam? || @sell_request.save
      flash[:success] = "Gracias. Revisaremos los datos de tu Porsche y te contactaremos con una propuesta."
      redirect_to new_sell_request_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def sell_request_params
    params.require(:sell_request).permit(:name, :email, :phone, :model, :year, :kilometers, :asking_price, :notes,
                                         :privacy_accepted, :website, photos: [])
  end
end
