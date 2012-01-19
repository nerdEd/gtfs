require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GTFS::LocalSource do
  describe '#new' do
    subject {lambda{GTFS::LocalSource.new(source_path)}}

    context 'with a local source path that is invalid' do
      let(:source_path) {File.expand_path(File.dirname(__FILE__) + '/../fixtures/not_here.zip')}

      it {should raise_error(GTFS::InvalidSourceException)}
    end

    context 'with a local source path to a zip w/o required files' do
      let(:source_path) {File.expand_path(File.dirname(__FILE__) + '/../fixtures/missing_files_gtfs.zip')}

      it {should raise_error(GTFS::InvalidSourceException)}
    end

    context 'with a local source path to a valid source zip' do
      let(:source_path) {File.expand_path(File.dirname(__FILE__) + '/../fixtures/valid_gtfs.zip')}
      
      it {should_not raise_error(GTFS::InvalidSourceException)}
    end
  end
end
