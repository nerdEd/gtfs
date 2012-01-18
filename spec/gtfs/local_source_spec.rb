require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GTFS::LocalSource do
  describe '#new' do
    context 'with a local source path that is invalid' do
      let(:source_path) {File.expand_path(File.dirname(__FILE__) + '/../fixtures/not_here.zip')}

      it 'should raise an exception' do
        lambda {GTFS::LocalSource.new(source_path)}.should raise_error(GTFS::InvalidSourceException)
      end
    end

    context 'with a local source path to a zip w/o required files' do
      let(:source_path) {File.expand_path(File.dirname(__FILE__) + '/../fixtures/missing_files_gtfs.zip')}

      it 'should raise an exception' do
        lambda {GTFS::LocalSource.new(source_path)}.should raise_error(GTFS::InvalidSourceException)
      end
    end

    context 'with a local source path to a valid source zip' do
      let(:source_path) {File.expand_path(File.dirname(__FILE__) + '/../fixtures/valid_gtfs.zip')}
      
      it 'should create a new source successfully' do
        lambda {GTFS::LocalSource.new(source_path)}.should_not raise_error(GTFS::InvalidSourceException)
      end
    end
  end
end
