class AddProcessedAtToCars < ActiveRecord::Migration[7.2]
  def change
    add_column :cars, :processed_at, :datetime
  end
end
