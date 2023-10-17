# frozen_string_literal: true

module Disbursements
  class CreateRetrospectivelyService
    prepend BaseOperation

    def call
      date_range.each do |datetime|
        DisburseMerchantOrdersBulkJob.perform_later(
          perform_datetime: datetime
        )
      end
    end

    private

    def orders_with_unique_created_at
      Merchant::Order
        .select('created_at')
        .distinct(:created_at)
        .order('created_at')
    end

    def start_time
      orders_with_unique_created_at.first.created_at.to_datetime
    end

    def end_time
      orders_with_unique_created_at.last.created_at.to_datetime + 14.days
    end

    def date_range
      start_time..end_time
    end
  end
end
