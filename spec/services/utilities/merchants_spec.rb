# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Utilities::Merchants do
  subject(:utility) do
    described_class.call(merchant)
  end

  describe '.daily_disbursement_frequency' do
    it 'returns the actual enum value' do
      expect(described_class.daily_disbursement_frequency).to eq('DAILY')
    end
  end

  describe '.weekly_disbursement_frequency' do
    it 'returns the actual enum value' do
      expect(described_class.weekly_disbursement_frequency).to eq('WEEKLY')
    end
  end

  describe '.disbursement_frequencies_enum' do
    let(:expected_enum) do
      { 'DAILY' => 'DAILY', 'WEEKLY' => 'WEEKLY' }
    end

    it 'returns the actual enum' do
      expect(described_class.disbursement_frequencies_enum).to eq(expected_enum)
    end
  end
end
