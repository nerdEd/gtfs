module GTFS
  class Agency
    include GTFS::Model

    column_prefix :agency_

    has_attributes :agency_id, :agency_name, :agency_url, :agency_timezone, :agency_lang, :agency_phone, :agency_fare_url, :agency_email
    has_optional_attrs :agency_id, :agency_lang, :agency_phone, :agency_fare_url, :agency_email

    attr_accessor *attrs

    collection_name :agencies
    required_file true
    uses_filename 'agency.txt'

    def self.parse_agencies(data, options={})
      return parse_models(data, options)
    end

    def self.generate_agencies(&block)
      CSV.generate do |csv|
        c = WriteCollection.new(csv, self)
        yield c
        c.array_to_csv
      end
    end
  end
end
