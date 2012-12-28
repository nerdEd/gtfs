module GTFS
  class Calendar
    include GTFS::Model

    has_required_attrs :service_id, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday, :start_date, :end_date
    attr_accessor *attrs

    collection_name :calendars
    required_file true
    uses_filename 'calendar.txt'

    def self.parse_calendars(data, options={})
      return parse_models(data, options)
    end
  end
end
