# frozen_string_literal: true

module Disbursements
  class CreateBulk
    prepend BaseOperation

    option :perform_datetime,
           type: Types::Strict::Date |
                 Types::Strict::DateTime |
                 Types::Strict::Time

    def call
      ActiveRecord::Base.transaction do
        ActiveRecord::Base.connection.execute(<<~SQL).clear
          lock merchants in access exclusive mode;
        SQL
        set_target_merchants
        disburse_merchants!
      end
    end

    private

    def set_target_merchants
      @target_merchants = GetTargetMerchantsService.call(perform_datetime: @perform_datetime).results
    end

    def disburse_merchants!
      @target_merchants.find_each do |merchant|
        DisburseMerchantOrdersByMerchantJob.perform_later(perform_datetime: @perform_datetime, merchant:)
      end
    end
  end
end
