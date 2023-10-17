# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Disbursements::CreateRetrospectivelyService do
  subject(:service) do
    described_class.call
  end

  describe '.call' do
    let!(:merchant) do
      create(
        :merchant,
        started_at: 3.months.ago,
        minimum_monthly_fee: 100.00
      )
    end

    let(:datetime_range) { '01-01-2023'.to_datetime..'07-01-2023'.to_datetime }

    before do
      datetime_range.each do |datetime|
        create(:merchant_order, merchant:, created_at: datetime)
      end
    end

    it 'invokes DisburseMerchantOrdersBulkJob expected times' do
      expect(DisburseMerchantOrdersBulkJob)
        .to receive(:perform_later)
        .exactly(21)
        .times
        .and_call_original
        .with(a_hash_including(:perform_datetime))
      service
    end
  end
end
