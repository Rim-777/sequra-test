# frozen_string_literal: true

module Utilities
  module Merchants
    module_function

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
