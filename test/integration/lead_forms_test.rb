require "test_helper"

class LeadFormsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "stock alert is saved and the visitor is sent back with a confirmation" do
    assert_difference "StockAlert.count", 1 do
      post stock_alerts_path, params: { stock_alert: { name: "Ana", phone: "600111222", model_line: "911", max_price: 150000, privacy_accepted: "true" } },
                              headers: { "HTTP_REFERER" => model_line_url(slug: "911") }
    end
    assert_redirected_to model_line_url(slug: "911")
    follow_redirect!
    assert_select ".flash-message", /Te avisaremos/
  end

  test "stock alert errors are shown in Spanish" do
    assert_no_difference "StockAlert.count" do
      post stock_alerts_path, params: { stock_alert: { name: "", privacy_accepted: "false" } }
    end
    assert_response :unprocessable_entity
    assert_select ".form__errors", /Nombre es obligatorio/
    assert_select ".form__errors", /Indica un email o un teléfono/
    assert_select ".form__errors", /política de privacidad debe aceptarse/
  end

  test "honeypot submissions are silently dropped" do
    assert_no_difference "StockAlert.count" do
      post stock_alerts_path, params: { stock_alert: { name: "Bot", email: "bot@example.com", privacy_accepted: "true", website: "spam.example" } }
    end
    assert_response :redirect
  end

  test "model pages preselect their range in the alert form" do
    get model_line_path(slug: "macan")
    assert_select "#avisame-form select[name='stock_alert[model_line]'] option[selected][value=macan]"
  end

  test "sell request stores the car details and photos" do
    get new_sell_request_path
    assert_response :success

    assert_difference "SellRequest.count", 1 do
      post sell_requests_path, params: { sell_request: {
        name: "Luis", email: "luis@example.com", model: "911 Carrera S (997)", year: 2008, kilometers: 90000, asking_price: 55000,
        privacy_accepted: "true", photos: [ fixture_file_upload("car.jpg", "image/jpeg") ]
      } }
    end
    assert_redirected_to new_sell_request_path
    assert_equal 1, SellRequest.last.photos.count
  end

  test "sell request rejects files that are not images" do
    assert_no_difference "SellRequest.count" do
      post sell_requests_path, params: { sell_request: {
        name: "Luis", email: "luis@example.com", model: "911", privacy_accepted: "true",
        photos: [ Rack::Test::UploadedFile.new(StringIO.new("hola"), "text/plain", original_filename: "nota.txt") ]
      } }
    end
    assert_response :unprocessable_entity
  end

  test "admin lead screens require an admin and list the requests" do
    StockAlert.create!(name: "Ana", email: "ana@example.com", model_line: "911", privacy_accepted: true)

    get admin_stock_alerts_path
    assert_redirected_to root_path

    sign_in users(:admin)
    get admin_stock_alerts_path
    assert_response :success
    assert_select "td", /Porsche 911/
    assert_select "a[href='#{admin_car_path(cars(:carrera))}']"

    get admin_sell_requests_path
    assert_response :success
  end
end
