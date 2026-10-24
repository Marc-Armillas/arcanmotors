require "test_helper"

class ModelLineTest < ActiveSupport::TestCase
  test "matches cars to their range by name or generation code" do
    assert_equal "911", ModelLine.for(Car.new(name: "Carrera 4S (992)")).slug
    assert_equal "911", ModelLine.for(Car.new(name: "911 Turbo")).slug
    assert_equal "718", ModelLine.for(Car.new(name: "Cayman GT4")).slug
    assert_equal "macan", ModelLine.for(Car.new(name: "Macan GTS")).slug
    assert_nil ModelLine.for(Car.new(name: "Carrera GT"))
  end

  test "SQL scope agrees with the Ruby matcher" do
    assert_equal [ cars(:carrera) ], ModelLine.cars(ModelLine.find("911"), Car.published).to_a
    assert_equal [ cars(:macan) ], ModelLine.cars(ModelLine.find("macan"), Car.published).to_a
  end

  test "with_stock lists only ranges that have published cars" do
    assert_equal %w[911 macan], ModelLine.with_stock.map(&:slug)
  end
end
