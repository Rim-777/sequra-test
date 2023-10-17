class DisburseMerchantOrdersBulkJob < ApplicationJob
  queue_as :bulk_disbursement

  def perform(perform_datetime: Time.current)
    Disbursements::CreateBulk.call(perform_datetime:)
  end
end
