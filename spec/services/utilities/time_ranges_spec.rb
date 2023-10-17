# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Utilities::TimeRanges do
  subject(:utility) do
    described_class
  end

  let(:current_time) { Time.current }

  describe 'yesterday_range_for' do
    let(:result) { utility.yesterday_range_for(date: current_time) }

    it 'returns a correct time range' do
      expect(result).to be_a(Range)
      expect(result.first).to eq(current_time.yesterday.beginning_of_day)
      expect(result.last).to eq(current_time.yesterday.end_of_day)
    end
  end

  describe '.last_week_range_for' do
    let(:result) { utility.last_week_range_for(date: current_time) }
    let(:last_week) { current_time.last_week }

    it 'returns a correct time range' do
      expect(result).to be_a(Range)
      expect(result.first).to eq(last_week.beginning_of_day)
      expect(result.last).to eq(last_week.end_of_week.end_of_day)
    end
  end

  describe '.last_month_range_for' do
    let(:result) { utility.last_month_range_for(date: current_time) }
    let(:last_month) { current_time.last_month }

    it 'returns a correct time range' do
      expect(result).to be_a(Range)
      expect(result.first).to eq(last_month.beginning_of_month.beginning_of_day)
      expect(result.last).to eq(last_month.end_of_month.end_of_day)
    end
  end

  describe '.current_month_range_for' do
    let(:result) { utility.current_month_range_for(date: current_time) }

    it 'returns a correct time range' do
      expect(result).to be_a(Range)
      expect(result.first).to eq(current_time.beginning_of_month.beginning_of_day)
      expect(result.last).to eq(current_time.end_of_month.end_of_day)
    end
  end
end
