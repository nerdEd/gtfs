module GTFS
  class FareAttribute
    include GTFS::Model

    has_required_attrs :fare_id, :price, :currency_type, :payment_method
    has_optional_attrs :transfer_duration, :transfers
    attr_accessor *attrs

    collection_name :fare_attributes
    required_file false
    uses_filename 'fare_attributes.txt'

    def self.parse_fare_attributes(data, options={})
      return parse_models(data, options)
    end
  end
end
