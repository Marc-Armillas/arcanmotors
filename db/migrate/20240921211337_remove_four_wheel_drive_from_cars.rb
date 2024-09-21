class RemoveFourWheelDriveFromCars < ActiveRecord::Migration[7.2]
  def change
    remove_column :cars, :four_wheel_drive, :boolean
  end
end
