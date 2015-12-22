module GTFS
  class Shape
    include GTFS::Model

    has_required_attrs :shape_id, :shape_pt_lat, :shape_pt_lon, :shape_pt_sequence
    has_optional_attrs :shape_dist_traveled
    attr_accessor *attrs

    collection_name :shapes
    required_file false
    uses_filename 'shapes.txt'
  end
end
