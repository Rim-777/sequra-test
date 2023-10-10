class CreateMerchants < ActiveRecord::Migration[7.0]
  def change
    create_table :merchants, id: :uuid do |t|
      t.string :email, null: false, index: { unique: true }
      t.datetime :started_at, null: false, index: true
      t.enum :disbursement_frequency, enum_type: :disbursement_frequency, null: false
      t.decimal :minimum_monthly_fee, null: false, precision: 10, scale: 2

      t.timestamps
    end
  end
end
