module GTFS
  class CalendarDate
    include GTFS::Model

    has_attributes :service_id, :date, :exception_type
    attr_accessor *attrs

    collection_name :calendar_dates
    required_file false
    uses_filename 'calendar_dates.txt'

    def self.parse_calendar_dates(data, options={})
      return parse_models(data, options)
    end
  end
end
