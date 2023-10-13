# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Disbursements::CreateBulk do
  let(:service_object) { described_class.new }
  subject(:service) do
    service_object.call
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
        merchant.merchant_orders.create!(amount: 1000, created_at: 6.days.ago)
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
      expect(Disbursements::Create).to receive(:call).exactly(5).times.and_call_original
      service
    end

    it 'creates an expected number of disbursements' do
      allow(Disbursements::GetTargetMerchantsService)
        .to receive(:call)
        .and_return(get_target_merchants_service)
      expect { service }.to change(Disbursement, :count).by(5)
    end
  end
end
