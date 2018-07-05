module GTFS
  class Trip
    include GTFS::Model

    column_prefix :trip_

    has_attributes :route_id, :service_id, :trip_id, :trip_headsign, :trip_short_name, :direction_id, :block_id, :shape_id, :wheelchair_accessible, :bikes_allowed
    has_optional_attrs :trip_headsign, :trip_short_name, :direction_id, :block_id, :shape_id, :wheelchair_accessible, :bikes_allowed
    attr_accessor *attrs


    collection_name :trips
    required_file true
    uses_filename 'trips.txt'

    def self.parse_trips(data, options={})
      return parse_models(data, options)
    end
  end
end
