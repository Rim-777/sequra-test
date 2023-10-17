# frozen_string_literal: true

require 'active_support/testing/time_helpers'

namespace :merchants do
  task disburse_retrospectively: :environment do
    puts 'Disbursement started'
    Disbursements::CreateRetrospectivelyService.call
  end
end
