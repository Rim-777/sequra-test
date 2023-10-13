# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Disbursements::GetTargetMerchantsService do
  let(:service_object) { described_class.new }

  subject(:service) do
    service_object.call
  end

  let!(:not_started_merchants) do
    create_list(:merchant, 3, started_at: 1.minute.from_now)
  end

  let(:daily_disbursed_merchants) do
    create_list(
      :merchant,
      3, started_at: 1.minute.ago,
         disbursement_frequency: CommonConstants::DAILY
    )
  end

  let(:same_weekday_weekly_disbursed_merchants) do
    create_list(
      :merchant, 2,
      disbursement_frequency: CommonConstants::WEEKLY, started_at: 7.days.ago
    )
  end

  let(:some_weekday_weekly_disbursed_merchants) do
    create_list(
      :merchant, 2,
      disbursement_frequency: CommonConstants::WEEKLY, started_at: 9.days.ago
    )
  end

  shared_context :create_merchant do
    before do
      daily_disbursed_merchants
      some_weekday_weekly_disbursed_merchants
      same_weekday_weekly_disbursed_merchants
    end
  end

  describe '#started_merchants' do
    let!(:relevant_merchants) do
      daily_disbursed_merchants + some_weekday_weekly_disbursed_merchants
    end

    it 'returns started merchants only' do
      expect(
        service_object.send(:started_merchants)
      ).to eq(relevant_merchants)
    end
  end

  describe '#daily_disbursed_merchants' do
    include_context :create_merchant

    it 'returns daily disbursed merchants only' do
      expect(
        service_object.send(:daily_disbursed_merchants)
      ).to eq(daily_disbursed_merchants)
    end
  end

  describe '#weekly_disbursed_merchants' do
    include_context :create_merchant

    it 'returns weekly merchants only registered on the same weekday' do
      expect(
        service_object.send(:weekly_disbursed_merchants)
      ).to eq(same_weekday_weekly_disbursed_merchants)
    end
  end

  describe '.call' do
    include_context :create_merchant

    let(:expected_merchants) { daily_disbursed_merchants + same_weekday_weekly_disbursed_merchants }

    it 'returns started daily merchants and weekly merchants only registered on the same weekday' do
      expect(service.results).to eq(expected_merchants)
    end
  end
end
