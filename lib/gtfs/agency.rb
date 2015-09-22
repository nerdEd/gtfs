module GTFS
  class Agency
    include GTFS::Model

    has_required_attrs :agency_name, :agency_url, :agency_timezone
    has_optional_attrs :agency_id, :agency_lang, :agency_phone, :agency_fare_url
    attr_accessor *attrs

    column_prefix :agency_

    collection_name :agencies
    required_file true
    uses_filename 'agency.txt'

    def id
      self.agency_id
    end
  end
end
