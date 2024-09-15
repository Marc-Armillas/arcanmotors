module Admin
  class CategoryTypesController < AdminController
    def index
      @category_types = CategoryType.all
    end
  end
end
