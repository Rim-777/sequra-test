# frozen_string_literal: true

module CsvMacros
  extend ActiveSupport::Concern

  included do |base|
    base::CSV_OPTIONS = {
      headers: true,
      col_sep: ';',
      header_converters: :symbol
    }.freeze

    private

    def row_invalid?(contract_class:, line_num:, row:)
      contract = contract_class.new.call({ attributes: row.to_h })

      return unless contract.failure?

      message = {
        line_num:,
        row:,
        error: contract.errors.to_h
      }

      fail!([message])
      true
    end
  end
end
