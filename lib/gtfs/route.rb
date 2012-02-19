module GTFS
  class Route
    include GTFS::Model

    has_required_attrs :id, :short_name, :long_name, :type
    has_optional_attrs :agency_id, :desc, :url, :color, :text_color
    attr_accessor *attrs

    column_prefix :route_

    def self.parse_routes(data)
      return parse_models(data)
    end
  end
end
