module GTFS
  class Route
    include GTFS::Model

    has_required_attrs :route_id, :route_short_name, :route_long_name, :route_type
    has_optional_attrs :agency_id, :route_desc, :route_url, :route_color, :route_text_color
    attr_accessor *attrs

    collection_name :routes
    required_file true
    uses_filename 'routes.txt'

    def id
      self.route_id
    end
  end
end
