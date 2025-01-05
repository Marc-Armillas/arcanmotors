class AddStatusToCars < ActiveRecord::Migration[7.2]
  def change
    add_column :cars, :status, :integer, default: 0
    add_column :cars, :is_public, :boolean, default: true
  end
end
