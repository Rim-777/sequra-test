class CreateMerchantOrdersDisbursements < ActiveRecord::Migration[7.0]
  def change
    create_table :merchant_orders_disbursements, id: :uuid do |t|
      t.uuid :merchant_order_id, foreign_key: true
      t.uuid :disbursement_id, foreign_key: true
      t.index(%i[merchant_order_id disbursement_id], unique: true,
              name: 'index_orders_disbursements_on_order_id_and_disbursement_id')

      add_foreign_key :merchant_orders_disbursements,
                      :merchant_orders,
                      column: :merchant_order_id

      add_foreign_key :merchant_orders_disbursements,
                      :disbursements,
                      column: :disbursement_id
      t.timestamps
    end
  end
end
