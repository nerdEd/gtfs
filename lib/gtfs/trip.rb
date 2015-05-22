module GTFS
  class Trip
    include GTFS::Model

    has_required_attrs :route_id, :service_id, :id
    has_optional_attrs :headsign, :short_name, :direction_id, :block_id, :shape_id, :wheelchair_accessible, :bikes_allowed
    attr_accessor *attrs

    column_prefix :trip_

    collection_name :trips
    required_file true
    uses_filename 'trips.txt'

    def self.parse_trips(data, options={})
      return parse_models(data, options)
    end
  end
end
