class AddNameToCategoryTypes < ActiveRecord::Migration[7.2]
  def change
    add_column :category_types, :name, :string
  end
end
