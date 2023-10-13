# frozen_string_literal: true

module Disbursements
  class Create
    prepend BaseOperation

    option :merchant, type: Types.Instance(Merchant)

    attr_reader :disbursement

    def call
      set_undisbursed_merchant_orders
      calculate_and_create_disbursement!
    end

    private

    def set_undisbursed_merchant_orders
      @undisbursed_merchant_orders =
        Merchants::Orders::GetUndisbursedService.call(merchant: @merchant).results
    end

    def calculate_and_create_disbursement!
      return if no_orders_found?

      calculate_gross_amount
      calculate_fee
      calculate_monthly_fee
      calculate_final_amount
      create_disbursement!
    end

    def calculate_gross_amount
      @gross_amount = @undisbursed_merchant_orders.sum(:amount)
    end

    def calculate_fee
      @fee = Merchants::CalculateFeeService.call(amount: @gross_amount).fee
    end

    def calculate_monthly_fee
      @monthly_fee = Merchants::CalculateMonthlyFeeService.call(merchant: @merchant).monthly_fee
    end

    def calculate_final_amount
      @final_amount = @gross_amount - @fee - @monthly_fee
    end

    def create_disbursement!
      @disbursement = Disbursement.new(amount: @final_amount, fee: @fee, monthly_fee: @monthly_fee)
      @disbursement.merchant_orders = @undisbursed_merchant_orders
      @disbursement.save!
    rescue ActiveRecord::RecordInvalid => e
      message = {
        merchant_id: @merchant.id,
        message: e.message
      }

      fail!([message])
    end

    def no_orders_found?
      @no_orders_found ||= @undisbursed_merchant_orders.empty?
    end
  end
end
