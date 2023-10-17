class CreateMerchantOrdersDisbursements < ActiveRecord::Migration[7.0]
  def change
    create_table :merchant_orders_disbursements, id: :uuid do |t|
      t.references :merchant_order,
                   type: :uuid,
                   references: :merchant_orders,
                   foreign_key: { to_table: :merchant_orders }
      t.references :disbursement,
                   type: :uuid,
                   references: :disbursements,
                   foreign_key: { to_table: :disbursements }

      t.index(%i[merchant_order_id disbursement_id],
              unique: true,
              name: 'index_orders_disbursements_on_order_id_and_disbursement_id')
      t.timestamps
    end
  end
end
