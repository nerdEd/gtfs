module GTFS
  class Level
    include GTFS::Model

    has_required_attrs :level_id, :level_index
    has_optional_attrs :level_name
    attr_accessor *attrs

    collection_name :levels
    required_file false
    uses_filename 'levels.txt'

    def self.parse_levels(data, options={})
      return parse_models(data, options)
    end
  end
end
