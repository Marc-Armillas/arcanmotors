module Admin
  class ContactRequestsController < AdminController
    def index
      @contact_requests = ContactRequest.all
    end
  end
end
