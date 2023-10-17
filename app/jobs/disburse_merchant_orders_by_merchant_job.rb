class DisburseMerchantOrdersByMerchantJob < ApplicationJob
  queue_as :default

  def perform(perform_datetime:, merchant:)
    Disbursements::Create.call(perform_datetime:, merchant:)
  end
end
