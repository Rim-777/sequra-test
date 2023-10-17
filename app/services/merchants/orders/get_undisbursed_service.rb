# frozen_string_literal: true

module Merchants
  module Orders
    class GetUndisbursedService
      prepend BaseOperation

      option :merchant, type: Types.Instance(Merchant)
      option :perform_datetime,
             type: Types::Strict::Date |
                   Types::Strict::DateTime |
                   Types::Strict::Time

      attr_reader :results

      def call
        @results =
          @merchant
          .merchant_orders
          .where(created_at: disbursement_range)
          .includes(:merchant_orders_disbursement)
          .where(merchant_orders_disbursements: { merchant_order_id: nil })
      end

      private

      def disbursement_range
        Merchants::GetDisbursementRangeService.call(
          merchant: @merchant,
          perform_datetime: @perform_datetime
        ).result
      end
    end
  end
end
