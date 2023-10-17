# frozen_string_literal: true

module MerchantOrders
  class CsvAttributesContract < Dry::Validation::Contract
    schema do
      required(:attributes).hash do
        required(:merchant_reference).filled(:string)
        required(:amount).filled(:string)
        required(:created_at).filled(:string)
      end
    end

    rule(%i[attributes amount]).validate(format: RegExp::AMOUNT)
    rule(%i[attributes created_at]).validate(format: RegExp::DATE_YYYY_MM_DD)
  end
end
