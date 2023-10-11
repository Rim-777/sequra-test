# frozen_string_literal: true

FactoryBot.define do
  sequence :email do |n|
    "merchant_#{n}@test.com"
  end
  factory :merchant do
    email
    started_at { 2.months.ago }
    minimum_monthly_fee { 77.77 }
    disbursement_frequency { CommonConstants::DAILY }

    trait :daily_disbursed do
      disbursement_frequency {  CommonConstants::DAILY }
    end

    trait :weekly_disbursed do
      disbursement_frequency {  CommonConstants::WEEKLY }
    end
  end
end
