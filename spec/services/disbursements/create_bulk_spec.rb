# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Disbursements::CreateBulk do
  let(:service_object) { described_class.new(perform_datetime:) }
  subject(:service) do
    service_object.call
  end

  let!(:perform_datetime) { Time.current }

  before do
    allow(Time).to receive(:current).and_return(perform_datetime)
  end

  describe '.call' do
    let(:daily_disbursed_merchants) do
      create_list(
        :merchant, 3,
        started_at: 2.days.ago,
        disbursement_frequency: CommonConstants::DAILY
      )
    end

    let(:same_weekday_weekly_disbursed_merchants) do
      create_list(
        :merchant, 2,
        disbursement_frequency: CommonConstants::WEEKLY, started_at: 7.days.ago
      )
    end

    let(:target_merchants) do
      Merchant.where(id: daily_disbursed_merchants + same_weekday_weekly_disbursed_merchants)
    end

    let!(:get_target_merchants_service) { double(results: target_merchants) }

    before do
      same_weekday_weekly_disbursed_merchants.each do |merchant|
        merchant.merchant_orders.create!(amount: 1000, created_at: 7.days.ago)
      end

      daily_disbursed_merchants.each do |merchant|
        merchant.merchant_orders.create!(amount: 1000, created_at: 1.day.ago)
      end
    end

    it 'invokes Disbursements::GetTargetMerchantsService' do
      expect(Disbursements::GetTargetMerchantsService).to receive(:call).and_call_original
      service
    end

    it 'invokes Disbursements::Create expected number of times' do
      expect(DisburseMerchantOrdersByMerchantJob)
        .to receive(:perform_later)
        .exactly(5).times
        .with(a_hash_including(perform_datetime:))
        .and_call_original
      service
    end
  end
end
