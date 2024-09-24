module AdminHelper
  def in_admin_controller?
    controller.class.name&.include?("Admin::")
  end
end