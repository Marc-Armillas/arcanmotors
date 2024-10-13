class ContactRequestsController < ApplicationController
  def new
    @contact_request = ContactRequest.new
    @contact_request.assign_attributes(car_id: params[:car_id]) if params[:car_id].present?
  end

  def create
    @contact_request = ContactRequest.new(contact_request_params)
    if @contact_request.save
      flash[:success] = "Solicitud enviada correctamente, nos pondremos en contacto contigo lo antes posible."
      redirect_to root_path
    else
      flash[:error] = "Error al enviar la solicitud."
      render :new
    end
  end

  private

  def contact_request_params
    params.require(:contact_request).permit(:name, :email, :phone, :subject, :message, :car_id)
  end
end
