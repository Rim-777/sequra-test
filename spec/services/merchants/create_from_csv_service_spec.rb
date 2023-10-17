# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Merchants::CreateFromCsvService do
  subject(:service) do
    described_class.call(file_path:)
  end

  describe '#call' do
    context 'success' do
      let(:file_path) { Rails.root.join('spec', 'support', 'files', 'merchants_test_success.csv').to_s }

      include_examples 'services/common/success'

      it 'properly parses the csv file' do
        expect { service }.to change(Merchant, :count).by(3)
      end

      it 'properly assigns attributes' do
        created_merchants = service.merchants
        expect(created_merchants.first)
          .to have_attributes(
            email: 'test@email-1.com',
            started_at: '2022-10-07'.to_date,
            disbursement_frequency: 'DAILY',
            minimum_monthly_fee: 100.00.to_d
          )

        expect(created_merchants.second)
          .to have_attributes(
            email: 'test@email-2.com',
            started_at: '2022-12-01'.to_date,
            disbursement_frequency: 'DAILY',
            minimum_monthly_fee: 200.00.to_d
          )

        expect(created_merchants.third)
          .to have_attributes(
            email: 'test@email-3.com',
            started_at: '2022-10-09'.to_date,
            disbursement_frequency: 'WEEKLY',
            minimum_monthly_fee: 300.00.to_d
          )
      end

      it 'properly returns bulk_merchant_attributes' do
        expect(service.bulk_merchant_attributes)
          .to eq(
            {
              'test_reference-1' => {
                disbursement_frequency: 'DAILY',
                email: 'test@email-1.com',
                minimum_monthly_fee: '100.0', started_at: '2022-10-07'
              },
              'test_reference-2' => {
                disbursement_frequency: 'DAILY',
                email: 'test@email-2.com',
                minimum_monthly_fee: '200.0',
                started_at: '2022-12-01'
              },
              'test_reference-3' => {
                disbursement_frequency: 'WEEKLY',
                email: 'test@email-3.com',
                minimum_monthly_fee: '300.0',
                started_at: '2022-10-09'
              }
            }
          )
      end
    end

    context 'failure' do
      let(:file_path) do
        Rails.root.join(
          'spec',
          'support',
          'files',
          'merchants_test_failure.csv'
        ).to_s
      end

      let(:expected_errors) do
        [
          {
            error: {
              attributes: {
                live_on: ['invalid format'],
                minimum_monthly_fee: ['invalid format'],
                reference: ['must be a string']
              }
            },
            line_num: 1,
            row: CSV::Row.new(
              %i[reference email live_on disbursement_frequency minimum_monthly_fee],
              [nil, 'test@email-2.com', '20-12-01', 'DAILY', 'some_non_amount']
            )
          }
        ]
      end

      include_examples 'services/common/failure'
    end
  end
end
