module GTFS
  class FeedInfo
    include GTFS::Model

    has_required_attrs :publisher_name, :publisher_url, :lang
    has_optional_attrs :start_date, :end_date, :version
    attr_accessor *attrs

    column_prefix :feed_

    collection_name :feed_infos
    required_file false
    uses_filename 'feed_info.txt'

    def self.parse_feed_infos(data, options={})
      return parse_models(data, options)
    end
  end
end
