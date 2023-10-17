# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Disbursements::Create do
  let(:service_object) { described_class.new(merchant:, perform_datetime: Time.current) }
  subject(:service) do
    service_object.call
  end

  describe '.call' do
    let!(:merchant) do
      create(
        :merchant,
        :daily_disbursed,
        started_at: 3.months.ago,
        minimum_monthly_fee: 100.00
      )
    end

    shared_examples :assigns_proper_attributes do
      it 'correctly counts attributes' do
        expect(
          service.disbursement
        ).to have_attributes(
          amount: expected_amount,
          fee: expected_fee,
          monthly_fee: expected_monthly_fee
        )
      end
    end

    context 'no merchant_orders found' do
      include_examples 'services/common/success'

      it 'does not create disbursements' do
        expect { service }.not_to change(Disbursement, :count)
      end

      it 'does ot assign any disbursement as a service result' do
        expect(service.disbursement).to be_nil
      end
    end

    context 'daily merchants' do
      let!(:today_merchant_orders) do
        create_list(
          :merchant_order, 2,
          merchant:,
          amount: 1000,
          created_at: Time.current
        )
      end

      let!(:yesterday_merchant_orders) do
        create_list(
          :merchant_order, 2,
          merchant:,
          amount: 1000,
          created_at: Time.current.yesterday
        )
      end

      let!(:last_week_merchant_order_disbursed) do
        create_list(
          :merchant_order, 2,
          merchant:,
          amount: 1000,
          created_at: Time.current.last_week.end_of_week
        )
      end

      let(:previous_disbursement) do
        create(
          :disbursement,
          monthly_fee: 100,
          created_at: Time.current.beginning_of_month
        )
      end

      before do
        previous_disbursement.merchant_orders << last_week_merchant_order_disbursed
      end

      let(:expected_fee) do
        # 2000(sum amount of actual orders) * 0.0085 = 17
        17
      end

      let(:expected_monthly_fee) do
        # monthly fee has been already paid
        0
      end

      let(:expected_amount) do
        # 2000 - 17 - 83
        1983
      end

      include_examples 'services/common/success'

      it 'creates a new disbursement' do
        expect { service }.to change(Disbursement, :count).from(1).to(2)
      end

      it 'assigns the disbursement as a service result' do
        service_disbursement = service.disbursement
        expect(service_disbursement).to be_present
        expect(service_disbursement).to be_a(Disbursement)
        expect(service_disbursement).not_to eq(:previous_disbursement)
      end

      it 'properly associates orders with the disbursement' do
        expect(
          service.disbursement.merchant_orders
        ).to eq(yesterday_merchant_orders)
      end

      include_examples :assigns_proper_attributes
    end

    context 'weekly merchants' do
      let!(:merchant) do
        create(
          :merchant,
          :weekly_disbursed,
          started_at: 3.months.ago,
          minimum_monthly_fee: 100.00
        )
      end

      let!(:this_week_merchant_orders) do
        create_list(
          :merchant_order, 2,
          merchant:,
          amount: 1000,
          created_at: Time.current.beginning_of_week
        )
      end

      let!(:last_week_merchant_orders) do
        create_list(
          :merchant_order, 2,
          merchant:,
          amount: 1000,
          created_at: Time.current.last_week.end_of_week
        )
      end

      let!(:last_month_merchant_orders) do
        create_list(
          :merchant_order, 2,
          merchant:,
          amount: 1000,
          created_at: Time.current.last_month.end_of_month
        )
      end

      let(:expected_fee) do
        # 2000(sum amount of actual orders) * 0.0085 = 17
        17
      end

      let(:expected_monthly_fee) do
        # 100(min monthly fee) - 17(last month fee) = 83
        83
      end

      let(:expected_amount) do
        # 2000(sum amount of last week orders) - 17 - 83
        1900
      end

      include_examples 'services/common/success'

      it 'creates one disbursement' do
        expect { service }.to change(Disbursement, :count).from(0).to(1)
      end

      it 'assigns a created disbursement to the service result' do
        service_disbursement = service.disbursement
        expect(service_disbursement).to be_present
        expect(service_disbursement).to be_a(Disbursement)
      end

      it 'properly associates orders with the disbursement' do
        expect(
          service.disbursement.merchant_orders
        ).to eq(last_week_merchant_orders)
      end

      include_examples :assigns_proper_attributes
    end

    context 'invalid disbursement attributes' do
      let(:invalid_disbursement) { Disbursement.new(amount: nil, fee: nil) }

      before do
        create(
          :merchant_order,
          merchant:,
          created_at: Time.current.yesterday
        )
        allow(Disbursement).to receive(:new).and_return(invalid_disbursement)
      end

      let(:expected_errors) do
        [
          {
            merchant_id: merchant.id,
            message: "Validation failed: Amount can't be blank, Fee can't be blank"
          }
        ]
      end

      include_examples 'services/common/failure'
    end
  end
end
