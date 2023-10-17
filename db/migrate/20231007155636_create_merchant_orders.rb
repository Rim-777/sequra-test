class CreateMerchantOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :merchant_orders, id: :uuid do |t|
      t.references :merchant,
                   type: :uuid,
                   references: :merchants,
                   foreign_key: { to_table: :merchants }

      t.decimal :amount, null: false, precision: 10, scale: 2



      t.timestamps
    end
  end
end
