# frozen_string_literal: true

module RegExp
  DATE_YYYY_MM_DD = /^\d{4}-(0?[1-9]|1[012])-(0?[1-9]|[12][0-9]|3[01])$/
  AMOUNT = /\A\s*\d+(\.[0-9]{1,2})?\s*\z/x
  DISBURSEMENT_FREQUENCY = /^(#{CommonConstants::DAILY}|#{CommonConstants::WEEKLY})$/
end
