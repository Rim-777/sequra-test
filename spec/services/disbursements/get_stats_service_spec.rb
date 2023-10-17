# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Disbursements::GetStatsService do
  subject(:service) do
    described_class.call(start_datetime:, end_datetime:)
  end

  describe '.call' do
    let(:start_datetime) { '01-07-2023'.to_datetime }
    let(:end_datetime) { '07-07-2023'.to_datetime }
    let(:datetime_range) { start_datetime..end_datetime }

    let!(:scoped_disbursement) do
      create(
        :disbursement,
        perform_datetime: start_datetime,
        fee: 1000,
        monthly_fee: 100,
        amount: 10_000
      )
    end

    let!(:another_scoped_disbursement) do
      create(
        :disbursement,
        perform_datetime: end_datetime,
        fee: 1000,
        monthly_fee: 100,
        amount: 10_000
      )
    end

    let!(:unscoped_disbursement) do
      create(
        :disbursement,
        perform_datetime: '07-07-2022'.to_datetime,
        fee: 1000,
        monthly_fee: 100,
        amount: 10_000
      )
    end

    let(:expected_stats) do
      { total_amount: 20_000, total_fee: 2000, total_monthly_fee: 200 }
    end

    it 'returns expected stats' do
      expect(service.result).to eq(expected_stats)
    end
  end
end
