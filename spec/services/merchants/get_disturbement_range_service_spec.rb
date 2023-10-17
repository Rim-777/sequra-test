# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Merchants::GetDisbursementRangeService do
  let(:service_object) { described_class.new(merchant:, perform_datetime:) }

  describe '.call' do
    let(:perform_datetime) { Time.current }

    context 'daily disbursed merchant' do
      let!(:merchant) { create(:merchant, :daily_disbursed) }
      let(:expected_range) { Utilities::TimeRanges.yesterday_range_for(date: perform_datetime) }

      it 'returns yesterday range for a given date' do
        expect(
          service_object.call.result
        ).to eq(expected_range)
      end
    end

    context 'weekly disbursed merchant' do
      let!(:merchant) { create(:merchant, :weekly_disbursed) }
      let(:expected_range) { Utilities::TimeRanges.last_week_range_for(date: perform_datetime) }

      it 'returns previous week range' do
        expect(
          service_object.call.result
        ).to eq(expected_range)
      end
    end
  end
end
