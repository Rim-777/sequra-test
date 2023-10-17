# frozen_string_literal: true

module Disbursements
  class GetStatsService
    prepend BaseOperation

    option :start_datetime,
           type: Types::Strict::Date |
                 Types::Strict::DateTime |
                 Types::Strict::Time

    option :end_datetime,
           type: Types::Strict::Date |
                 Types::Strict::DateTime |
                 Types::Strict::Time

    attr_reader :result

    def call
      set_disbursements
      set_stats
    end

    private

    def set_disbursements
      @disbursements =
        Disbursement.where(perform_datetime: @start_datetime..@end_datetime)
    end

    def set_stats
      @result = {
        total_amount: @disbursements.sum(:amount).to_f,
        total_fee: @disbursements.sum(:fee).to_f,
        total_monthly_fee: @disbursements.sum(:monthly_fee).to_f
      }
    end
  end
end
