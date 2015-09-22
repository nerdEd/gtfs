module GTFS
  class FeedInfo
    include GTFS::Model

    has_required_attrs :feed_publisher_name, :feed_publisher_url, :feed_lang
    has_optional_attrs :feed_start_date, :feed_end_date, :feed_version
    attr_accessor *attrs

    column_prefix :feed_

    collection_name :feed_infos
    required_file false
    uses_filename 'feed_info.txt'
  end
end
