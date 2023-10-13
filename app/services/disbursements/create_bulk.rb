# frozen_string_literal: true

module Disbursements
  class CreateBulk
    prepend BaseOperation

    def call
      set_target_merchants
      disburse_merchants!
    end

    private

    def set_target_merchants
      @target_merchants = GetTargetMerchantsService.call.results
    end

    def disburse_merchants!
      @target_merchants.find_each do |merchant|
        disbursement_create_service = Disbursements::Create.call(merchant:)

        next if disbursement_create_service.success?

        fail!(disbursement_create_service.errors)
      end
    end
  end
end
