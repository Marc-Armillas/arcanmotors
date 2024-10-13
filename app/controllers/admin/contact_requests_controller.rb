module Admin
  class ContactRequestsController < AdminController
    def index
      @contact_requests = ContactRequest.all.order(created_at: :desc)
    end

    def update
      contact_request = ContactRequest.find(params[:id])
      if contact_request.update(contact_request_params)
        flash[:success] = "Solicitud actualizada correctamente"
      else
        flash[:error] = "Error al actualizar la solicitud"
      end

      redirect_to admin_contact_requests_path
    end

    private

    def contact_request_params
      params.require(:contact_request).permit(:viewed)
    end
  end
end
