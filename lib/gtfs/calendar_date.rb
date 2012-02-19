module GTFS
  class CalendarDate
    include GTFS::Model

    has_required_attrs :service_id, :date, :exception_type
    attr_accessor *attrs

    def self.parse_calendar_dates(data)
      return parse_models(data)
    end
  end
end
