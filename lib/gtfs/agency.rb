module GTFS
  class Agency
    include GTFS::Model

    has_required_attrs :name, :url, :timezone
    has_optional_attrs :id, :lang, :phone, :fare_url
    attr_accessor *attrs

    column_prefix :agency_

    def self.parse_agencies(data)
      return parse_models(data)
    end
  end
end
