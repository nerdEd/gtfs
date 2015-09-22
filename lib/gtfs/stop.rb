module GTFS
  class Stop
    include GTFS::Model

    has_required_attrs :stop_id, :stop_name, :stop_lat, :stop_lon
    has_optional_attrs :stop_code, :stop_desc, :zone_id, :stop_url, :location_type, :parent_station, :stop_timezone, :wheelchair_boarding
    column_prefix :stop_
    attr_accessor *attrs

    collection_name :stops
    required_file true
    uses_filename 'stops.txt'

    LOCATION_TYPE_STOP = 0
    LOCATION_TYPE_STATION = 1
  end
end
