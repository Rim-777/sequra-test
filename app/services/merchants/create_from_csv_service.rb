# frozen_string_literal: true

require 'English'
require 'csv'

module Merchants
  class CreateFromCsvService
    prepend BaseOperation
    include CsvMacros

    option :file_path, type: Types::CsvFormat
    attr_reader :bulk_merchant_attributes, :merchants

    def call
      set_merchant_attributes
      create_merchants!
    end

    private

    def set_merchant_attributes
      @bulk_merchant_attributes ||= {}

      CSV.foreach(@file_path, **CSV_OPTIONS) do |row|
        exit! if row_invalid?(contract_class: Merchants::CsvAttributesContract, line_num: $INPUT_LINE_NUMBER, row:)

        @bulk_merchant_attributes[row.fetch(:reference)] =
          {
            email: row[:email],
            started_at: row[:live_on],
            disbursement_frequency: row[:disbursement_frequency],
            minimum_monthly_fee: row[:minimum_monthly_fee]
          }
      end
    end

    def create_merchants!
      @merchants = Merchant.create!(@bulk_merchant_attributes.values)
    end
  end
end
