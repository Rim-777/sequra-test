# frozen_string_literal: true

module Utilities
  module TimeRanges
    module_function

    def today_range
      today.beginning_of_day..today.end_of_day
    end

    def yesterday_range
      yesterday = Date.yesterday
      yesterday.beginning_of_day..yesterday.end_of_day
    end

    def last_week_range
      last_week = today.last_week
      last_week.beginning_of_week.beginning_of_day..last_week.end_of_week.end_of_day
    end

    def last_month_range
      beginning_of_last_month..end_of_last_month
    end

    def current_month_range
      current_time.beginning_of_month..current_time.end_of_month
    end

    def current_time
      Time.current
    end

    def today
      Date.today
    end

    def last_month
      current_time.last_month
    end

    def beginning_of_last_month
      last_month.beginning_of_month
    end

    def end_of_last_month
      last_month.end_of_month
    end
  end
end
