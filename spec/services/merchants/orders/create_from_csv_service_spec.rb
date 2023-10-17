# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Merchants::Orders::CreateFromCsvService do
  subject(:service) do
    described_class.call(merchants_scv_file_path:, orders_scv_file_path:)
  end

  describe '#call' do
    let(:merchants_scv_file_path) do
      Rails.root.join(
        'spec',
        'support',
        'files',
        'merchants_test_success.csv'
      ).to_s
    end

    let(:orders_scv_file_path) do
      Rails.root.join(
        'spec',
        'support',
        'files',
        'orders_test_success.csv'
      ).to_s
    end

    context 'success' do
      let(:created_merchant_orders) { Merchant::Order.all }

      include_examples 'services/common/success'

      it 'invokes Merchants::CreateFromCsvService with proper inputs' do
        expect(Merchants::CreateFromCsvService)
          .to receive(:call)
          .with(file_path: merchants_scv_file_path)
          .and_call_original
        service
      end

      it 'properly creates merchant orders' do
        expect { service }.to change(Merchant::Order, :count).by(3)
      end

      it 'properly assigns attributes' do
        service

        expect(created_merchant_orders)
          .to include(
            an_object_having_attributes(
              merchant_id: Merchant.find_by!(email: 'test@email-1.com').id,
              amount: 100.00
            )
          )

        expect(created_merchant_orders)
          .to include(
            an_object_having_attributes(
              merchant_id: Merchant.find_by!(email: 'test@email-2.com').id,
              amount: 200.00
            )
          )

        expect(created_merchant_orders)
          .to include(
            an_object_having_attributes(
              merchant_id: Merchant.find_by!(email: 'test@email-3.com').id,
              amount: 300.00
            )
          )
      end
    end

    context 'failure' do
      context 'merchant parsing failure' do
        let(:merchant_parsing_service) do
          double(success?: false, errors: expected_errors, bulk_merchant_attributes: [])
        end

        before do
          allow(Merchants::CreateFromCsvService).to receive(:call).and_return(merchant_parsing_service)
        end

        let(:expected_errors) { ['some errors'] }

        include_examples 'services/common/failure'
      end

      context 'invalid csv' do
        let(:orders_scv_file_path) do
          Rails.root.join('spec', 'support', 'files', 'orders_test_failure.csv').to_s
        end

        let(:expected_errors) do
          [
            {
              error: {
                attributes: {
                  amount: ['invalid format'],
                  merchant_reference: ['must be a string']
                }
              },
              line_num: 1,
              row: CSV::Row.new(
                %i[merchant_reference amount created_at],
                [nil, 'some text', '2022-10-07']
              )
            }
          ]
        end

        include_examples 'services/common/failure'
      end
    end
  end
end
