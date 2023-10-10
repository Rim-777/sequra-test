# frozen_string_literal: true

FactoryBot.define do
  factory :merchant do
    email { '123@trest.com' }
    started_at { Date.yesterday }
    minimum_monthly_fee { 77.77 }
    disbursement_frequency { 'DAILY' }
  end
end
