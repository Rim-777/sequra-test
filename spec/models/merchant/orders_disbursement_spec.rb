# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Merchant::OrdersDisbursement, type: :model do
  it {
    should belong_to(:merchant_order)
      .inverse_of(:merchant_orders_disbursement)
      .class_name('Merchant::Order')
      .with_foreign_key(:merchant_order_id)
  }

  it {
    should belong_to(:disbursement)
      .inverse_of(:merchant_orders_disbursements)
      .class_name('Disbursement')
  }
end
