# frozen_string_literal: true

module Utilities
  class Merchants
    prepend BaseUtility

    param :merchant, type: Types.Instance(Merchant)

    def disbursement_range
      case @merchant.disbursement_frequency
      when self.class.daily_disbursement_frequency
        Utilities::TimeRanges.yesterday_range
      when self.class.weekly_disbursement_frequency
        Utilities::TimeRanges.last_week_range
      end
    end

    class << self
      def disbursement_frequencies_enum
        @disbursement_frequencies_enum ||= Merchant.disbursement_frequencies
      end

      def daily_disbursement_frequency
        disbursement_frequencies_enum.fetch(CommonConstants::DAILY)
      end

      def weekly_disbursement_frequency
        disbursement_frequencies_enum.fetch(CommonConstants::WEEKLY)
      end
    end
  end
end
