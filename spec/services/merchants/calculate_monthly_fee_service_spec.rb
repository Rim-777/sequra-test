# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Merchants::CalculateMonthlyFeeService do
  let(:service_object) { described_class.new(merchant:) }

  subject(:service) do
    service_object.call
  end

  describe '.call' do
    shared_examples :zero_monthly_fee do
      it 'returns zero monthly fee' do
        expect(service.monthly_fee).to be_zero
      end
    end

    shared_examples :invokes_all_steps do
      it 'invokes all steps' do
        expect(service_object).to receive(:set_monthly_fee)
        service
      end
    end

    context 'recently started merchant' do
      let(:merchant) { create(:merchant, started_at: Date.today.beginning_of_month) }

      it 'exit at the first step' do
        expect(service_object).to receive(:exit!)
        service
      end

      include_examples :zero_monthly_fee
    end

    context 'long time started merchant' do
      let(:minimum_monthly_fee) { 84.00 }

      let(:merchant) do
        create(
          :merchant,
          started_at: 2.months.ago.end_of_month,
          minimum_monthly_fee:
        )
      end

      context 'minimum monthly fee reached' do
        before do
          create_list(:merchant_order, 2,
                      amount: 5000,
                      merchant:,
                      created_at: 1.months.ago.end_of_month)
        end

        include_examples :invokes_all_steps

        include_examples :zero_monthly_fee
      end

      context 'minimum monthly fee not reached' do
        before do
          create(
            :merchant_order,
            amount: 1000,
            merchant:,
            created_at: 1.months.ago.end_of_month
          )
        end

        let(:expected_monthly_fee) do
          # 1000 * 0.0085 = 8.5
          # 84 - 8.5 = 75.5
          75.5
        end

        include_examples :invokes_all_steps

        it 'returns diff between min monthly fe and last month fee and' do
          expect(service.monthly_fee).to eq(expected_monthly_fee)
        end
      end
    end
  end
end
