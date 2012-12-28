module GTFS
  class FareRule
    include GTFS::Model

    has_required_attrs :fare_id
    has_optional_attrs :route_id, :origin_id, :destination_id, :contains_id
    attr_accessor *attrs

    collection_name :fare_rules
    required_file false
    uses_filename 'fare_rules.txt'

    def self.parse_fare_rules(data, options={})
      return parse_models(data, options)
    end
  end
end
