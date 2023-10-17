# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Merchants::Orders::GetUndisbursedService do
  subject(:service) do
    described_class.new(merchant:, perform_datetime: current_time)
  end

  let(:current_time) { Time.current }

  let!(:merchant) { create(:merchant, :weekly_disbursed) }

  describe '#call' do
    let!(:last_week_merchant_order) do
      create(:merchant_order, merchant:, created_at: current_time.last_week)
    end

    let!(:disbursed_last_week_merchant_order) do
      create(:merchant_order, merchant:, created_at: current_time.last_week)
    end

    let!(:disbursement) { create(:disbursement) }

    let!(:two_weeks_ago_merchant_order) do
      create(:merchant_order, merchant:, created_at: 2.weeks.ago.end_of_week)
    end

    let!(:disbursement) { create(:disbursement) }

    context 'weekly disbursement' do
      let!(:this_week_merchant_order) do
        create(:merchant_order, merchant:, created_at: current_time.beginning_of_week)
      end

      before do
        disbursement.merchant_orders << disbursed_last_week_merchant_order
      end

      it 'contains last week merchant orders only' do
        expect(service.call.results).to contain_exactly(last_week_merchant_order)
      end
    end

    context 'daily disbursement' do
      let!(:merchant) { create(:merchant, :daily_disbursed) }
      let!(:yesterday_beginning_merchant_order) do
        create(:merchant_order, merchant:, created_at: current_time.yesterday.beginning_of_day)
      end

      let!(:yesterday_end_merchant_order) do
        create(:merchant_order, merchant:, created_at: current_time.yesterday.end_of_day)
      end

      let!(:disbursed_yesterday_end_merchant_order) do
        create(:merchant_order, merchant:, created_at: current_time.yesterday.end_of_day)
      end

      before do
        disbursement.merchant_orders << disbursed_yesterday_end_merchant_order
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
