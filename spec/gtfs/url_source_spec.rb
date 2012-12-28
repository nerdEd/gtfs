require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GTFS::URLSource do
  context 'with a URI to a valid source zip' do
    let(:source_path) {'http://dl.dropbox.com/u/416235/work/valid_gtfs.zip'}
    it 'should create a new source successfully' do
      VCR.use_cassette('valid_gtfs_uri') do
        lambda {GTFS::URLSource.new(source_path, {})}.should_not raise_error(GTFS::InvalidSourceException)
      end
    end
  end

  context 'with a non-existent URI' do
    let(:source_path) {'http://www.edschmalzle.com/gtfs.zip'}
    it 'should raise an exception' do
      VCR.use_cassette('invalid_gtfs_uri') do
        lambda {GTFS::URLSource.new(source_path, {})}.should raise_error(GTFS::InvalidSourceException)
      end
    end
  end
end
