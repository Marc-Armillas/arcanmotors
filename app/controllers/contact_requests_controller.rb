class ContactRequestsController < ApplicationController
  def new
    @contact_request = ContactRequest.new
    @contact_request.assign_attributes(car_id: params[:car_id]) if params[:car_id].present?
  end

  def create
    @contact_request = ContactRequest.new(contact_request_params)
    if @contact_request.save
      flash[:success] = "Thank you for your message. We will contact you soon!"
      redirect_to root_path
    else
      flash[:error] = "There was an error sending your message. Please try again."
      render :new
    end
  end

  private

  def contact_request_params
    params.require(:contact_request).permit(:name, :email, :phone, :subject, :message, :car_id)
  end
end
