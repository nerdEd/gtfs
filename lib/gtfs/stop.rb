module GTFS
  class Stop 
    include GTFS::Model
    required_attrs :id, :name, :lat, :lon
    optional_attrs :code, :desc, :zone_id, :url, :location_type, :parent_station, :timezone
    column_prefix :stop_
    attr_accessor *attrs

    LOCATION_TYPE_STOP = 0
    LOCATION_TYPE_STATION = 1

    def self.parse_stops(data)
      return parse_models(data)
    end
  end
end

