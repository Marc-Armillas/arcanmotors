class CreateCars < ActiveRecord::Migration[7.2]
  def change
    create_table :cars do |t|
      t.decimal :price
      t.string :name
      t.text :description
      t.integer :year
      t.integer :kilometers

      t.timestamps null: false
    end
  end
end
