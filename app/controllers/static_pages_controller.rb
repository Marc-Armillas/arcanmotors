class StaticPagesController < ApplicationController
  def home
    @cars = Car.where(in_home_page: true).with_attached_images.last(15)
  end

  def legal
    render template: "static_pages/legal/index"
  end

  def about_us; end

  def contact_us; end

  def cookies_policy; end

  # Starts as a static page but if in the future we have more than 1 should create a db_table/model/controller
  def services; end

  # Starts as a static page but if in the future we have more than 1 should create a db_table/model/controller
  def projects; end
end
