# frozen_string_literal: true

class Merchant < ApplicationRecord
  has_many :merchant_orders,
           class_name: 'Merchant::Order',
           inverse_of: :merchant,
           dependent: :destroy

  validates :email,
            :started_at,
            :disbursement_frequency,
            :minimum_monthly_fee,
            presence: true

  validates :email, uniqueness: true

  enum disbursement_frequency: { DAILY: CommonConstants::DAILY, WEEKLY: CommonConstants::WEEKLY }
end
