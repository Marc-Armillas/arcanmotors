module Admin
  class ContactRequestsController < AdminController
    def index
      @contact_requests = ContactRequest.all.order(created_at: :desc)
    end
  end
end
