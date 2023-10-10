# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Disbursement, type: :model do
  it {
    should have_many(:merchant_orders_disbursements)
      .inverse_of(:disbursement)
      .class_name('Merchant::OrdersDisbursement')
      .dependent(:destroy)
  }

  it {
    should have_many(:merchant_orders)
      .class_name('Merchant::Order')
      .through(:merchant_orders_disbursements)
  }

  it { should validate_presence_of(:amount) }
  it { should validate_presence_of(:fee) }
  it { should validate_presence_of(:monthly_fee) }
end
