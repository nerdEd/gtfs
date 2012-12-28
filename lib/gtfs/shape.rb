module GTFS
  class Shape
    include GTFS::Model

    has_required_attrs :id, :pt_lat, :pt_lon, :pt_sequence
    has_optional_attrs :dist_traveled
    attr_accessor *attrs

    collection_name :shapes
    required_file false
    uses_filename 'shapes.txt'

    column_prefix :shape_

    def self.parse_shapes(data, options={})
      return parse_models(data, options)
    end
  end
end
