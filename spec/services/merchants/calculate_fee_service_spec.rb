# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Merchants::CalculateFeeService do
  subject(:service) do
    described_class.call(amount:)
  end

  describe '.call' do
    shared_examples :expected_fee_calculation do
      it 'correctly calculate fee' do
        expect(service.fee).to eq(expected_fee)
      end
    end

    context 'amount < 50' do
      let(:amount) { 49 }
      let(:expected_fee) { 0.49 }

      include_examples :expected_fee_calculation
    end

    context 'amount >= 50 < 300' do
      let(:amount) { 299 }
      let(:expected_fee) { 2.84 }

      include_examples :expected_fee_calculation
    end

    context 'amount >= 300' do
      let(:amount) { 301 }
      let(:expected_fee) { 2.56 }
      include_examples :expected_fee_calculation
    end
  end
end
