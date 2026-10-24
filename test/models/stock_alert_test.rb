require "test_helper"

class StockAlertTest < ActiveSupport::TestCase
  def alert(**attrs)
    StockAlert.new({ name: "Ana", email: "ana@example.com", privacy_accepted: true }.merge(attrs))
  end

  test "needs a way to contact the person and privacy consent" do
    assert alert.valid?
    assert_not alert(email: nil, phone: nil).valid?
    assert_not alert(privacy_accepted: false).valid?
  end

  test "matching_cars filters by range and budget among published cars" do
    assert_equal [ cars(:carrera) ], alert(model_line: "911").matching_cars.to_a
    assert_empty alert(model_line: "911", max_price: 100_000).matching_cars
    assert_equal [ cars(:macan) ], alert(max_price: 100_000).matching_cars.to_a
  end

  test "builds a WhatsApp number from Spanish phones" do
    assert_equal "34600111222", alert(phone: "600 111 222").whatsapp_number
    assert_equal "34600111222", alert(phone: "+34 600 111 222").whatsapp_number
    assert_nil alert(phone: "123").whatsapp_number
  end
end
