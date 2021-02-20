module GTFS
  class Attribution
    include GTFS::Model

    has_required_attrs :organization_name
    has_optional_attrs :attribution_id, :agency_id, :route_id, :trip_id, :is_producer,
    :is_operator, :is_authority, :attribution_url, :attribution_email, :attribution_phone

    attr_accessor *attrs

    collection_name :attributions

    required_file false
    uses_filename 'attributions.txt'

    def self.parse_attributions(data, options={})
      return parse_models(data, options)
    end
  end
end
