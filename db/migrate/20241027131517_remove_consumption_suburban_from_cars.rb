class RemoveConsumptionSuburbanFromCars < ActiveRecord::Migration[7.2]
  def change
    remove_column :cars, :consumption_suburban
  end
end
