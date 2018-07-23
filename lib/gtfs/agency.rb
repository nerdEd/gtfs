module GTFS
  class Agency
    include GTFS::Model

    column_prefix :agency_

    has_attributes :agency_id, :agency_name, :agency_url, :agency_timezone, :agency_lang, :agency_phone, :agency_fare_url, :agency_email
    set_attributes_optional :agency_id, :agency_lang, :agency_phone, :agency_fare_url, :agency_email
    attr_accessor *attrs

    collection_name :agencies
    required_file true
    uses_filename 'agency.txt'

    def self.parse_agencies(data, options={})
      return parse_models(data, options)
    end
  end
end
