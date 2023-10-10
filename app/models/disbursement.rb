# frozen_string_literal: true

class Disbursement < ApplicationRecord
  has_many :merchant_orders_disbursements,
           class_name: 'Merchant::OrdersDisbursement',
           inverse_of: :disbursement,
           dependent: :destroy

  has_many :merchant_orders,
           class_name: 'Merchant::Order',
           through: :merchant_orders_disbursements

  validates :amount, :fee, :monthly_fee, presence: true
end
