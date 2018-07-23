module GTFS
  class FeedInfo
    include GTFS::Model

    column_prefix :feed_

    has_attributes :feed_publisher_name, :feed_publisher_url, :feed_lang, :feed_start_date, :feed_end_date, :feed_version
    set_attributes_optional :feed_start_date, :feed_end_date, :feed_version
    attr_accessor *attrs

    collection_name :feed_infos
    required_file false
    uses_filename 'feed_info.txt'

    def self.parse_feed_infos(data, options={})
      return parse_models(data, options)
    end
  end
end
