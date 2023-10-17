# frozen_string_literal: true

module Merchants
  class GetDisbursementRangeService
    prepend BaseOperation

    option :merchant, type: Types.Instance(Merchant)
    option :perform_datetime,
           type: Types::Strict::Date |
                 Types::Strict::DateTime |
                 Types::Strict::Time

    attr_reader :result

    def call
      @result =
        case @merchant.disbursement_frequency
        when Utilities::Merchants.daily_disbursement_frequency
          Utilities::TimeRanges.yesterday_range_for(date: @perform_datetime)
        when Utilities::Merchants.weekly_disbursement_frequency
          Utilities::TimeRanges.last_week_range_for(date: @perform_datetime)
        end
    end
  end
end
