class CreateStockAlerts < ActiveRecord::Migration[7.2]
  def change
    create_table :stock_alerts do |t|
      t.string :name, null: false
      t.string :email
      t.string :phone
      t.string :model_line
      t.integer :max_price
      t.text :notes
      t.boolean :handled, null: false, default: false
      t.timestamps
    end
  end
end
