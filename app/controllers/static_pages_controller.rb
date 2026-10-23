class StaticPagesController < ApplicationController
  def home
    published = Car.published.with_attached_images.includes(:make)
    @stock_count = published.count
    @cars = published.where(in_home_page: true).order(id: :desc).limit(10).to_a
    @cars = published.order(id: :desc).limit(10).to_a if @cars.empty?
  end

  def legal
    render template: "static_pages/legal/index"
  end

  def about_us; end

  def cookies_policy; end

  # Starts as a static page but if in the future we have more than 1 should create a db_table/model/controller
  def services; end

  # Starts as a static page but if in the future we have more than 1 should create a db_table/model/controller
  def projects; end
end
