module GTFS
  class Frequency
    include GTFS::Model

    has_required_attrs :trip_id, :start_time, :end_time, :headway_secs
    has_optional_attrs :exact_times
    attr_accessor *attrs

    collection_name :frequencies
    required_file false
    uses_filename 'frequencies.txt'

    def self.parse_frequencies(data, options={})
      return parse_models(data, options)
    end
  end
end
