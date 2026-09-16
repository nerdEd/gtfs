require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GTFS::URLSource do
  context 'with a URI to a valid source zip' do
    let(:source_path) {'https://developers.google.com/transit/gtfs/examples/sample-feed.zip'}
    it 'should create a new source successfully' do
      VCR.use_cassette('valid_gtfs_uri') do
        lambda {GTFS::URLSource.new(source_path, {})}.should_not raise_error(GTFS::InvalidSourceException)
      end
    end
  end

  context 'with a URI causing redirects' do
    let(:source_path) {'https://api.gtfs-data.jp/v2/organizations/asatetu/feeds/asakaigantetsudo/files/feed.zip'} # 302 Found
    it 'should create a new source successfully' do
      VCR.use_cassette('redirect_gtfs_uri') do
        lambda {GTFS::URLSource.new(source_path, {})}.should_not raise_error(GTFS::InvalidSourceException)
      end
    end
  end

  context 'with a non-existent URI' do
    let(:source_path) {'https://example.org/gtfs.zip'}
    it 'should raise an exception' do
      VCR.use_cassette('invalid_gtfs_uri') do
        lambda {GTFS::URLSource.new(source_path, {})}.should raise_error(GTFS::InvalidSourceException)
      end
    end
  end
end
