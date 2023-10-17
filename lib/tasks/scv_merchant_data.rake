# frozen_string_literal: true

namespace :csv_merchant_data do
  desc 'imports merchants and orders from csv files'

  task import: :environment do
    merchants_scv_file_path = Rails.root.join('lib', 'files', 'merchants.csv').to_s
    orders_scv_file_path =  Rails.root.join('lib', 'files', 'orders.csv').to_s
    puts 'Import started'

    service = Merchants::Orders::CreateFromCsvService.call(merchants_scv_file_path:, orders_scv_file_path:)
    puts service.errors if service.failure?
    puts 'Import completed'
  end
end
