class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :title
      t.string :description
      t.string :address
      t.string :city
      t.string :photo
      t.float :price
      t.integer :stock
      t.float :latitude
      t.float :longitude
      t.boolean :status, default: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
