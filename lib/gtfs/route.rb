module GTFS
  class Route
    include GTFS::Model

    column_prefix :route_

    has_attributes :route_id, :agency_id, :route_short_name, :route_long_name, :route_desc, :route_type, :route_url, :route_color, :route_text_color
    has_optional_attrs :route_agency_id, :route_desc, :route_url, :route_color, :route_text_color
    attr_accessor *attrs


    collection_name :routes
    required_file true
    uses_filename 'routes.txt'

    def self.parse_routes(data, options={})
      return parse_models(data, options)
    end
  end
end
