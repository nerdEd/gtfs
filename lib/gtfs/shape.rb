module GTFS
  class Shape
    include GTFS::Model

    required_attrs :id, :pt_lat, :pt_lon, :pt_sequence
    optional_attrs :dist_traveled
    attr_accessor *attrs

    column_prefix :shape_

    def self.parse_shapes(data)
      return parse_models(data)
    end
  end
end
