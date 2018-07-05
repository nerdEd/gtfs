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

  describe 'FeedInfo.generate_feed_infos' do
    it "should produce the correct csv output" do
      csv = GTFS::FeedInfo.generate_csv do |feed_infos|
        feed_infos << {
          publisher_name: 'P',
          publisher_url: 'http://feed.test/test',
          lang: 'FR',
          start_date: '01012018',
          end_date: '02022018'
        }
      end
      csv.should eq("feed_publisher_name,feed_publisher_url,feed_lang,feed_start_date,feed_end_date\n"+
      "P,http://feed.test/test,FR,01012018,02022018\n")
    end

    it "should filter dynamically unused csv columns" do
      csv = GTFS::FeedInfo.generate_csv do |feed_infos|
        feed_infos << {
          publisher_name: 'P',
          publisher_url: 'http://feed.test/test',
          lang: 'FR',
          start_date: '01012018',
        }
        feed_infos << {
          publisher_name: 'P',
          publisher_url: 'http://feed.test/test',
          lang: 'FR',
        }
        feed_infos << {
          publisher_name: 'P',
          publisher_url: 'http://feed.test/test',
          lang: 'FR',
          start_date: '01012018',
        }
      end
      csv.should eq("feed_publisher_name,feed_publisher_url,feed_lang,feed_start_date\n"+
      "P,http://feed.test/test,FR,01012018\n"+
      "P,http://feed.test/test,FR,\n"+
      "P,http://feed.test/test,FR,01012018\n"
      )
    end
  end
end
