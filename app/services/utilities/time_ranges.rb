# frozen_string_literal: true

module Utilities
  module TimeRanges
    module_function

    def yesterday_range_for(date:)
      yesterday = date.yesterday
      yesterday.beginning_of_day..yesterday.end_of_day
    end

    def last_week_range_for(date:)
      last_week = date.last_week
      last_week.beginning_of_day..last_week.end_of_week.end_of_day
    end

    def last_month_range_for(date:)
      beginning_of_last_month_for(date:)..end_of_last_month_for(date:)
    end

    def current_month_range_for(date:)
      date.beginning_of_month..date.end_of_month
    end

    def beginning_of_last_month_for(date:)
      date.last_month.beginning_of_month
    end

    def end_of_last_month_for(date:)
      date.last_month.end_of_month
    end
  end
end
