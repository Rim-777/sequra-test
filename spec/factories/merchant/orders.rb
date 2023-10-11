# frozen_string_literal: true

FactoryBot.define do
  factory :merchant_order, class: 'Merchant::Order' do
    amount { '1000' }
  end
end
