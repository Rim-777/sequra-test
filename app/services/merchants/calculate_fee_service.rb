# frozen_string_literal: true

module Merchants
  class CalculateFeeService
    prepend BaseOperation

    option :amount, type: Types::Nominal::Decimal

    attr_reader :fee

    def call
      @fee =
        case @amount
        when ->(a) { a < 50 } then (@amount * 0.01)
        when ->(a) { a >= 50 && a <= 300 } then (@amount * 0.0095)
        when ->(a) { a > 300 } then (@amount * 0.0085)
        end.round(2)
    end
  end
end
