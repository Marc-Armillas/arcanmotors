class CreateCategoryTypes < ActiveRecord::Migration[7.2]
  def change
    create_table :category_types do |t|
      t.timestamps
    end
  end
end
