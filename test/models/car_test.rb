require "test_helper"

class CarTest < ActiveSupport::TestCase
  test "published excludes sold and hidden cars" do
    assert_equal [ cars(:carrera), cars(:macan) ].sort_by(&:id), Car.published.order(:id).to_a
  end

  test "to_param builds a descriptive slug ending in the id" do
    car = cars(:carrera)
    assert_equal "porsche-911-carrera-4s-2021-#{car.id}", car.to_param
  end

  test "marking a car as sold hides it from the site and the home page" do
    car = cars(:macan)
    car.update!(status: :sold)
    assert_not car.is_public
    assert_not car.in_home_page
    assert_not_includes Car.published, car
  end

  test "price changes recalculate tax fields" do
    car = cars(:carrera)
    car.update!(price: 100_000)
    assert_equal 121_000, car.tax.to_i
  end
end
