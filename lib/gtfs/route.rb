module GTFS
  class Route
    include GTFS::Model

    has_required_attrs :id, :short_name, :long_name, :type
    has_optional_attrs :agency_id, :desc, :url, :color, :text_color
    attr_accessor *attrs

    column_prefix :route_

    collection_name :routes
    required_file true
    uses_filename 'routes.txt'

    def self.parse_routes(data, options={})
      return parse_models(data, options)
    end
  end
end
