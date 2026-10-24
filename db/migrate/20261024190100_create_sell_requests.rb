class CreateSellRequests < ActiveRecord::Migration[7.2]
  def change
    create_table :sell_requests do |t|
      t.string :name, null: false
      t.string :email
      t.string :phone
      t.string :model, null: false
      t.integer :year
      t.integer :kilometers
      t.integer :asking_price
      t.text :notes
      t.boolean :handled, null: false, default: false
      t.timestamps
    end
  end
end
