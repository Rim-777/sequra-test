# frozen_string_literal: true

module Utilities
  module TimeRanges
    module_function

    def today_range
      today = Date.today
      today.beginning_of_day..today.end_of_day
    end

    def yesterday_range
      yesterday = Date.yesterday
      yesterday.beginning_of_day..yesterday.end_of_day
    end

    def last_week_range
      last_week = Date.today.last_week
      last_week.beginning_of_week..last_week.end_of_week
    end
  end
end
