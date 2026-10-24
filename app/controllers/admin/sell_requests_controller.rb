module Admin
  class SellRequestsController < AdminController
    def index
      @sell_requests = SellRequest.with_attached_photos.order(handled: :asc, created_at: :desc)
    end

    def show
      @sell_request = SellRequest.find(params[:id])
    end

    def update
      SellRequest.find(params[:id]).update!(handled: params.dig(:sell_request, :handled) == "true")
      redirect_to admin_sell_requests_path, notice: "Solicitud actualizada"
    end

    def destroy
      SellRequest.find(params[:id]).destroy!
      redirect_to admin_sell_requests_path, notice: "Solicitud eliminada"
    end
  end
end
