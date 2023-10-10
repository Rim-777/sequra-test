# frozen_string_literal: true
class Merchant::OrdersDisbursement < ApplicationRecord
  belongs_to :merchant_order,
             class_name: 'Merchant::Order',
             inverse_of: :merchant_orders_disbursement,
             foreign_key: :merchant_order_id
  belongs_to :disbursement,
             class_name: 'Disbursement',
             inverse_of: :merchant_orders_disbursements

  validates :merchant_order_id, uniqueness: { scope: :disbursement_id }
end
