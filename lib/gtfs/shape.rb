module GTFS
  class Shape
    include GTFS::Model

    column_prefix :shape_

    has_attributes :shape_id, :shape_pt_lat, :shape_pt_lon, :shape_pt_sequence, :shape_dist_traveled
    set_attributes_optional :shape_dist_traveled
    attr_accessor *attrs

    collection_name :shapes
    required_file false
    uses_filename 'shapes.txt'

    def self.parse_shapes(data, options={})
      return parse_models(data, options)
    end
  end
end
