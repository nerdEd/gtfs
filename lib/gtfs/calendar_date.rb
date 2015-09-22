module GTFS
  class CalendarDate
    include GTFS::Model

    has_required_attrs :service_id, :date, :exception_type
    attr_accessor *attrs

    collection_name :calendar_dates
    required_file true
    uses_filename 'calendar_dates.txt'
  end
end
