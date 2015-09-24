module GTFS

  class ServicePeriod

    ISO_DAYS_OF_WEEK = [
      :monday,
      :tuesday,
      :wednesday,
      :thursday,
      :friday,
      :saturday,
      :sunday
    ]

    attr_accessor :service_id,
                  :start_date,
                  :end_date,
                  :added_dates,
                  :except_dates,
                  :monday,
                  :tuesday,
                  :wednesday,
                  :thursday,
                  :friday,
                  :saturday,
                  :sunday

    def self.to_date(date)
      date.is_a?(Date) ? date : Date.parse(date)
    end

    def self.from_calendar(calendar)
      attrs = {
          service_id: calendar.service_id,
          start_date: to_date(calendar.start_date),
          end_date: to_date(calendar.end_date),
      }
      ISO_DAYS_OF_WEEK.each { |i| attrs[i] = (calendar.send(i).to_i > 0) }
      self.new(attrs)
    end

    def initialize(attrs)
      @added_dates = Set.new
      @except_dates = Set.new
      attrs.each do |key, val|
        instance_variable_set("@#{key}", val)
      end
    end

    def id
      self.service_id
    end

    def iso_service_weekdays
      ISO_DAYS_OF_WEEK.map { |i| (self.send(i)) }
    end

    def add_date(date)
      self.added_dates << ServicePeriod.to_date(date)
    end

    def except_date(date)
      self.except_dates << ServicePeriod.to_date(date)
    end

    def expand_service_range
      range = added_dates + except_dates
      range << start_date if start_date
      range << end_date if end_date
      self.start_date = range.min
      self.end_date = range.max
    end
  end
end
