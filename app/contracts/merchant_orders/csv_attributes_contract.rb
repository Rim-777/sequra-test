# frozen_string_literal: true

module MerchantOrders
  class CsvAttributesContract < Dry::Validation::Contract
    schema do
      required(:attributes).hash do
        required(:merchant_reference).filled(:string)
        required(:amount).filled(:string)
      end
    end

    rule(%i[attributes amount]).validate(format: RegExp::AMOUNT)
  end
end
