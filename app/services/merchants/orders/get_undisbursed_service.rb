# frozen_string_literal: true

module Merchants
  module Orders
    class GetUndisbursedService
      prepend BaseOperation

      option :merchant, type: Types.Instance(Merchant)

      attr_reader :results

      def call
        set_undisbursed_merchant_orders
        filter_orders_by_disbursement_frequency
      end

      private

      def set_undisbursed_merchant_orders
        @results =
          @merchant
          .merchant_orders
          .includes(:merchant_orders_disbursement)
          .where(merchant_orders_disbursements: { merchant_order_id: nil })
      end

      def filter_orders_by_disbursement_frequency
        return if @results.empty?

        @results = @results.where(created_at: disbursement_range)
      end

      def disbursement_range
        Utilities::Merchants.call(@merchant).disbursement_range
      end
    end
  end
end
