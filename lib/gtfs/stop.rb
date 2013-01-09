module GTFS
  class Stop 
    include GTFS::Model
    
    has_required_attrs :id, :name, :lat, :lon
    has_optional_attrs :code, :desc, :zone_id, :url, :location_type, :parent_station, :timezone, :wheelchair_boarding
    column_prefix :stop_
    attr_accessor *attrs

    collection_name :stops
    required_file true
    uses_filename 'stops.txt'

    LOCATION_TYPE_STOP = 0
    LOCATION_TYPE_STATION = 1

    def self.parse_stops(data, options={})
      return parse_models(data, options)
    end
  end
end

