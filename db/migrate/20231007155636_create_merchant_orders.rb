class CreateMerchantOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :merchant_orders, id: :uuid do |t|
      t.uuid :merchant_id, index: true, foreign_key: true
      t.decimal :amount, null: false, precision: 10, scale: 2

      add_foreign_key :merchant_orders,
                      :merchants,
                      column: :merchant_id

      t.timestamps
    end
  end
end
