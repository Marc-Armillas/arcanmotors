class CreateContactRequests < ActiveRecord::Migration[7.2]
  def change
    create_table :contact_requests do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :subject
      t.text :message
      t.boolean :viewed, default: false
      t.references :car, null: true, foreign_key: true

      t.timestamps
    end
  end
end
