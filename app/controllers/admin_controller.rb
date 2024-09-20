class AdminController < ApplicationController
  layout "admin"

  before_action :authenticate_user!
  before_action :check_admin

  def index

  end

  private

  def check_admin
    unless current_user.present? && current_user.admin?
      redirect_to root_path, alert: 'Access denied'
    end
  end
end