module GTFS
  class StopTime
    include GTFS::Model

    has_required_attrs :trip_id, :arrival_time, :departure_time, :stop_id, :stop_sequence
    has_optional_attrs :stop_headsign, :pickup_type, :drop_off_type, :shape_dist_traveled
    attr_accessor *attrs

    collection_name :stop_times
    required_file true
    uses_filename 'stop_times.txt'
  end
end
