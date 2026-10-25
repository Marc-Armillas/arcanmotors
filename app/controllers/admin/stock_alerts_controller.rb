module Admin
  class StockAlertsController < AdminController
    def index
      @stock_alerts = StockAlert.order(handled: :asc, created_at: :desc)
    end

    def update
      StockAlert.find(params[:id]).update!(handled: params.dig(:stock_alert, :handled) == "true")
      redirect_to admin_stock_alerts_path, notice: "Aviso actualizado"
    end

    def destroy
      StockAlert.find(params[:id]).destroy!
      redirect_to admin_stock_alerts_path, notice: "Aviso eliminado"
    end
  end
end
