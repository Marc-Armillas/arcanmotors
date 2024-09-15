module Admin
  class CategoryTypesController < ApplicationController
    def index
      @category_types = CategoryType.all
    end
  end
end
