# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DisburseMerchantOrdersByMerchantJob, type: :job do
  let(:merchant) { create(:merchant) }
  let(:expected_argument) { { perform_datetime:, merchant: } }

  let(:perform_datetime) { 1.day.ago }

  it 'invokes the proper service' do
    expect(Disbursements::Create).to receive(:call).with(**expected_argument)
    described_class.perform_now(**expected_argument)
  end
end
