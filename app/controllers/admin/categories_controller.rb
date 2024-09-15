module Admin
  class CategoriesController < AdminController
    def index
      @categories = Category.all
    end
  end
end
