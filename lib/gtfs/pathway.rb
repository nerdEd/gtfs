module GTFS
  class Pathway
    include GTFS::Model

    has_required_attrs :pathway_id, :from_stop_id, :to_stop_id, :pathway_mode, :is_bidirectional
    has_optional_attrs :length, :traversal_time, :stair_count, :max_slope, :min_width, :signposted_as,
                       :reversed_signposted_as

    attr_accessor *attrs
    collection_name :pathways

    required_file false
    uses_filename 'pathways.txt'

    def self.parse_pathways(data, options={})
      return parse_models(data, options)
    end
  end
end