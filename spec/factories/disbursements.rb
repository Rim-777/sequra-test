# frozen_string_literal: true

FactoryBot.define do
  factory :disbursement do
    amount { '1000' }
    fee { '10' }
    monthly_fee { '30' }
  end
end
