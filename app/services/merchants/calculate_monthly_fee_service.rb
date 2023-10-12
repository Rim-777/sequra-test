# frozen_string_literal: true

module Merchants
  class CalculateMonthlyFeeService
    prepend BaseOperation

    option :merchant, type: Types.Instance(Merchant)

    attr_reader :monthly_fee

    def call
      init_monthly_fee
      set_previous_month_amount
      set_previous_month_fee
      set_monthly_fee
    end

    private

    def init_monthly_fee
      @monthly_fee = 0.0
      exit! if @merchant.started_at > Utilities::TimeRanges.end_of_last_month
    end

    def set_previous_month_amount
      @prev_month_amount =
        @merchant
        .merchant_orders
        .where(created_at: Utilities::TimeRanges.last_month_range)
        .sum(:amount)
    end

    def set_previous_month_fee
      @prev_month_fee = CalculateFeeService.call(amount: @prev_month_amount).fee
    end

    def set_monthly_fee
      difference = @merchant.minimum_monthly_fee - @prev_month_fee
      @monthly_fee = difference if difference.positive?
    end
  end
end
