module GTFS
  class Agency
    include GTFS::Model

    has_required_attrs :name, :url, :timezone
    has_optional_attrs :id, :lang, :phone, :fare_url, :email
    has_csv_attributes :id, :name, :url, :timezone, :lang, :phone, :fare_url, :email

    attr_accessor *attrs

    column_prefix :agency_

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
