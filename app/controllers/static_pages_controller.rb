class StaticPagesController < ApplicationController
  def home
    @categories = Category.all
    @category_types = CategoryType.all
    @cars = Car.all
  end

  def about_us
  end

  def contact_us
  end

  def privacy_policy
  end

  # Starts as a static page but if in the future we have more than 1 should create a db_table/model/controller
  def services
  end

  # Starts as a static page but if in the future we have more than 1 should create a db_table/model/controller
  def projects
  end
end
