# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Merchant::Order, type: :model do
  it { should belong_to(:merchant).inverse_of(:merchant_orders) }
  it {
    should have_one(:merchant_orders_disbursement)
      .inverse_of(:merchant_order)
      .class_name('Merchant::OrdersDisbursement')
      .with_foreign_key(:merchant_order_id)
  }

  it { should have_one(:disbursement).through(:merchant_orders_disbursement) }
  it { should validate_presence_of(:amount) }
end
