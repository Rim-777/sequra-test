# frozen_string_literal: true

module Merchants
  module Orders
    class CreateFromCsvService
      prepend BaseOperation
      include CsvMacros

      option :merchants_scv_file_path, type: Types::CsvFormat
      option :orders_scv_file_path, type: Types::CsvFormat

      def call
        ActiveRecord::Base.transaction do
          parse_merchants_csv
          parse_orders_csv!
        end
      end

      private

      def parse_merchants_csv
        merchant_parsing_service =
          Merchants::CreateFromCsvService.call(file_path: @merchants_scv_file_path)
        @merchant_attributes = merchant_parsing_service.bulk_merchant_attributes
        return if merchant_parsing_service.success?

        exit_with_errors!(merchant_parsing_service.errors)
      end

      def parse_orders_csv!
        CSV.foreach(@orders_scv_file_path, **CSV_OPTIONS) do |row|
          exit! if row_invalid?(
            contract_class: MerchantOrders::CsvAttributesContract, line_num: $., row:
          )

          merchant_reference = row.fetch(:merchant_reference)
          merchant_email = @merchant_attributes.fetch(merchant_reference).fetch(:email)
          merchant = Merchant.find_by!(email: merchant_email)
          merchant.merchant_orders.create!(amount: row.fetch(:amount))
        end
      end
    end
  end
end
