class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.integer :width
      t.integer :height
      t.integer :depth
      t.integer :weight
      t.integer :stock_level

      t.timestamps
    end
    add_index :products, :name, :unique => true
  end
end
