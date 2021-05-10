class CreateDeliveries < ActiveRecord::Migration[6.1]
  def change
    create_table :deliveries do |t|
      t.string :tracking_number, null: false
      t.integer :status, null: false
      t.integer :carrier, null: false
      t.integer :package_weigth_unit
      t.float :package_weigth
      t.integer :package_dimensions_unit
      t.float :package_length
      t.float :package_width
      t.float :package_heigth

      t.timestamps
    end

    add_index :deliveries, ['tracking_number', 'carrier'], unique: true
  end
end
