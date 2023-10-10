# frozen_string_literal: true

class Merchant::Order < ApplicationRecord
  belongs_to :merchant, inverse_of: :merchant_orders
  has_one :merchant_orders_disbursement,
          class_name: 'Merchant::OrdersDisbursement',
          inverse_of: :merchant_order, foreign_key: :merchant_order_id

  has_one :disbursement, through: :merchant_orders_disbursement
  validates :amount, presence: true
end
