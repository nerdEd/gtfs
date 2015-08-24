require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GTFS::FeedInfo do
  describe 'FeedInfo.parse_feed_infos' do
    let(:header_line) {"feed_publisher_name,feed_publisher_url,feed_lang,feed_start_date,feed_end_date,feed_version\n"}
    let(:invalid_header_line) {"feed_publisher_name,feed_publisher_url,feed_start_date,feed_end_date,feed_version\n"}
    let(:valid_line) {"Torrance Transit,http://Transit.TorranceCA.gov,en,20141102,20151003,1413\n"}
    let(:invalid_line) {"Torrance Transit,http://Transit.TorranceCA.gov\n"}

    subject {GTFS::FeedInfo.parse_feed_infos(source_text, opts)}

    include_examples 'models'
  end
end
