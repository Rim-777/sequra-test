class CreateDisbursements < ActiveRecord::Migration[7.0]
  def change
    create_table :disbursements, id: :uuid do |t|
      t.decimal :amount, null: false, precision: 10, scale: 2
      t.decimal :fee, null: false, precision: 10, scale: 2
      t.decimal :monthly_fee, null: false, precision: 10, scale: 2, default: 0
      t.datetime :perform_datetime

      t.timestamps
    end
  end
end
