class AddCategoryTypeIdToCategories < ActiveRecord::Migration[7.2]
  def change
    add_reference :categories, :category_type, null: false, foreign_key: true
  end
end
