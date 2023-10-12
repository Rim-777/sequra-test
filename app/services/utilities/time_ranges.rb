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
      last_week.beginning_of_week.beginning_of_day..last_week.end_of_week.end_of_day
    end

    def last_month
      Time.current.last_month
    end

    def beginning_of_last_month
      last_month.beginning_of_month.beginning_of_day
    end

    def end_of_last_month
      last_month.end_of_month.end_of_day
    end

    def last_month_range
      beginning_of_last_month..end_of_last_month
    end
  end
end
