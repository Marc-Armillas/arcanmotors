require "test_helper"

class CarsHelperTest < ActionView::TestCase
  include SeoHelper

  test "car_price uses Spanish formatting without decimals" do
    assert_equal "139.900 €", car_price(cars(:carrera))
  end

  test "car_price asks to consult when there is no price" do
    car = cars(:carrera)
    car.price = nil
    assert_equal "Consultar", car_price(car)
  end

  test "car_km adds thousands separator and unit" do
    assert_equal "28.400 km", car_km(cars(:carrera))
  end

  test "car_specs translates enums and skips empty values" do
    specs = car_specs(cars(:carrera)).to_h
    assert_equal "Semiautomático", specs["Cambio"]
    assert_equal "Gasolina", specs["Combustible"]
    assert_equal "Total", specs["Tracción"]
    assert_equal "450 CV (331 kW)", specs["Potencia"]
    assert_not specs.key?("Puertas")
  end

  test "whatsapp_url encodes the prefilled message" do
    assert_match %r{\Ahttps://wa\.me/\d*\?text=Hola%2C%20me%20interesa\z}, whatsapp_url("Hola, me interesa")
  end
end
