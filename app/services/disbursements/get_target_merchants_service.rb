# frozen_string_literal: true

module Disbursements
  class GetTargetMerchantsService
    prepend BaseOperation

    attr_reader :results

    def call
      @results = daily_disbursed_merchants.or(weekly_disbursed_merchants)
    end

    private

    def daily_disbursed_merchants
      started_merchants
        .where(
          disbursement_frequency: Utilities::Merchants.daily_disbursement_frequency
        )
    end

    def weekly_disbursed_merchants
      started_merchants.where(
        'extract(dow from started_at) = ? AND disbursement_frequency = ?',
        Date.today.wday,
        Utilities::Merchants.weekly_disbursement_frequency
      )
    end

    def started_merchants
      @started_merchants ||=
        Merchant
          .includes(:merchant_orders)
          .where('started_at <= ?', Time.current)
    end
  end
end