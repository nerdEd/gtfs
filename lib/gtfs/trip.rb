module GTFS
  class Trip
    include GTFS::Model

    required_attrs :route_id, :service_id, :id
    optional_attrs :headsign, :short_name, :direction_id, :block_id, :shape_id
    attr_accessor *attrs

    column_prefix :trip_

    def self.parse_trips(data)
      return parse_models(data)
    end
  end
end
