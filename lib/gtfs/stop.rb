module GTFS
  class Stop
    include GTFS::Model

    column_prefix :stop_

    has_attributes :stop_id, :stop_code, :stop_name, :stop_desc, :stop_lat, :stop_lon, :zone_id, :stop_url, :location_type, :parent_station, :stop_timezone, :wheelchair_boarding
    has_optional_attrs :stop_code, :stop_desc, :zone_id, :stop_url, :location_type, :parent_station, :stop_timezone, :wheelchair_boarding
    attr_accessor *attrs

    collection_name :stops
    required_file true
    uses_filename 'stops.txt'

    LOCATION_TYPE_STOP = 0
    LOCATION_TYPE_STATION = 1

    def self.parse_stops(data, options={})
      return parse_models(data, options)
    end

    def self.generate_stops(&block)
      generate_csv &block
    end
  end
end
