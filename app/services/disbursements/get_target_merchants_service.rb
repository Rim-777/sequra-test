# frozen_string_literal: true

module Disbursements
  class GetTargetMerchantsService
    prepend BaseOperation

    attr_reader :results

    option :perform_datetime,
           type: Types::Strict::Date |
                 Types::Strict::DateTime |
                 Types::Strict::Time

    def call
      @results = daily_disbursed_merchants.or(weekly_disbursed_merchants)
    end

    private

    def daily_disbursed_merchants
      started_merchants
        .where(
          disbursement_frequency: Utilities::Merchants.daily_disbursement_frequency
        ).includes(merchant_orders: :merchant_orders_disbursement)
        .where(merchant_orders: { created_at: previous_day_range })
        .where(merchant_orders_disbursements: { merchant_order_id: nil })
    end

    def weekly_disbursed_merchants
      started_merchants.where(
        'extract(dow from started_at) = ? AND disbursement_frequency = ?',
        @perform_datetime.wday,
        Utilities::Merchants.weekly_disbursement_frequency
      ).includes(merchant_orders: :merchant_orders_disbursement)
                       .where(merchant_orders: { created_at: previous_week_range })
                       .where(merchant_orders_disbursements: { merchant_order_id: nil })
    end

    def started_merchants
      @started_merchants ||= Merchant.where('started_at <= ?', @perform_datetime)
    end

    def previous_day_range
      Utilities::TimeRanges.yesterday_range_for(date: @perform_datetime)
    end

    def previous_week_range
      Utilities::TimeRanges.last_week_range_for(date: @perform_datetime)
    end
  end
end
