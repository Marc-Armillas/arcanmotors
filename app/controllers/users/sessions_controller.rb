# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController

  def new
    super
  end

  def after_sign_in_path_for(resource)
    if request.referer&.include?('/admin22') && current_user.admin?
      admin_path
    else
      root_path
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
end
