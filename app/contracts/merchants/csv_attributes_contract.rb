# frozen_string_literal: true

module Merchants
  class CsvAttributesContract < Dry::Validation::Contract
    schema do
      required(:attributes).hash do
        required(:reference).filled(:string)
        required(:email).filled(:string)
        required(:live_on).filled(:string)
        required(:disbursement_frequency).filled(:string)
        required(:minimum_monthly_fee).filled(:string)
      end
    end

    rule(%i[attributes live_on]).validate(format: RegExp::DATE_YYYY_MM_DD)
    rule(%i[attributes minimum_monthly_fee]).validate(format: RegExp::AMOUNT)
  end
end
