module GTFS
  class Trip
    include GTFS::Model

    has_required_attrs :route_id, :service_id, :trip_id
    has_optional_attrs :trip_headsign, :trip_short_name, :direction_id, :block_id, :shape_id, :wheelchair_accessible
    attr_accessor *attrs

    collection_name :trips
    required_file true
    uses_filename 'trips.txt'
  end
end
