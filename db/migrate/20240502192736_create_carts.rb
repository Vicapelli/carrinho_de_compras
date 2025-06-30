class CreateCarts < ActiveRecord::Migration[7.1]
  def change
    create_table :carts do |t|
      t.decimal :total_price, precision: 17, scale: 2
      t.datetime :abandoned_at
      t.timestamps
    end
  end
end
