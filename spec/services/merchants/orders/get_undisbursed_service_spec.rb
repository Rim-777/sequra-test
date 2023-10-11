# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Merchants::Orders::GetUndisbursedService do
  subject(:service) do
    described_class.new(merchant:)
  end

  let!(:merchant) { create(:merchant, :weekly_disbursed) }

  describe '#set_undisbursed_merchant_orders' do
    let!(:undisbursed_merchant_orders) do
      create_list(:merchant_order, 2, merchant:)
    end

    let!(:disbursed_merchant_order) { create(:merchant_order, merchant:) }
    let!(:disbursement) { create(:disbursement) }

    before do
      disbursement.merchant_orders << disbursed_merchant_order
    end

    it 'contains undisbursed merchant orders only' do
      service.send(:set_undisbursed_merchant_orders)
      expect(service.results).to eq(undisbursed_merchant_orders)
    end
  end

  describe '#call' do
    let!(:last_week_merchant_order) do
      create(:merchant_order, merchant:, created_at: Date.today.last_week)
    end

    let!(:this_week_merchant_order) do
      create(:merchant_order, merchant:, created_at: Date.today.beginning_of_week)
    end

    let!(:two_weeks_ago_merchant_order) do
      create(:merchant_order, merchant:, created_at: 2.weeks.ago.end_of_week)
    end

    context 'weekly disbursement' do
      it 'contains last week merchant orders only' do
        expect(service.call.results).to contain_exactly(last_week_merchant_order)
      end
    end

    context 'daily disbursement' do
      let!(:merchant) { create(:merchant, :daily_disbursed) }
      let!(:yesterday_beginning_merchant_order) do
        create(:merchant_order, merchant:, created_at: Date.yesterday.beginning_of_day)
      end

      let!(:yesterday_end_merchant_order) do
        create(:merchant_order, merchant:, created_at: Date.yesterday.end_of_day)
      end

      it 'contains last week merchant orders only' do
        expect(service.call.results)
          .to contain_exactly(
            yesterday_beginning_merchant_order,
            yesterday_end_merchant_order
          )
      end
    end
  end
end
