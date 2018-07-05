module GTFS
  class FareAttribute
    include GTFS::Model

    has_attributes :fare_id, :price, :currency_type, :payment_method, :transfers, :agency_id, :transfer_duration
    has_optional_attrs :agency_id, :transfer_duration
    attr_accessor *attrs

    collection_name :fare_attributes
    required_file false
    uses_filename 'fare_attributes.txt'

    def self.parse_fare_attributes(data, options={})
      return parse_models(data, options)
    end
  end
end
