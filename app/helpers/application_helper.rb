module ApplicationHelper
  def flash_class(type)
    case type
    when "notice"
      "bg-blue-100 border-t border-b border-blue-500 text-blue-700 px-4 py-3"
    when "alert"
      "bg-red-100 border-t border-b border-red-500 text-red-700 px-4 py-3"
    when "success"
      "bg-green-100 border-t border-b border-green-500 text-green-700 px-4 py-3"
    when "error"
      "bg-yellow-100 border-t border-b border-yellow-500 text-yellow-700 px-4 py-3"
    else
      "bg-gray-100 border-t border-b border-gray-500 text-gray-700 px-4 py-3"
    end
  end

  def in_admin_controller?
    controller.class.name&.include?("Admin::")
  end
end
