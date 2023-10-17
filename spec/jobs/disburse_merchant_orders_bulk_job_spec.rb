# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DisburseMerchantOrdersBulkJob, type: :job do
  let(:expected_argument) { { perform_datetime: } }

  context 'with default arguments' do
    let(:perform_datetime) { Time.current }

    before do
      allow(Time).to receive(:current).and_return(perform_datetime)
    end

    it 'invokes the proper service' do
      expect(Disbursements::CreateBulk).to receive(:call).with(**expected_argument)
      described_class.perform_now
    end
  end

  context 'with a given arguments' do
    let(:perform_datetime) { 1.day.ago }

    it 'invokes the proper service' do
      expect(Disbursements::CreateBulk).to receive(:call).with(**expected_argument)
      described_class.perform_now(**expected_argument)
    end
  end
end
