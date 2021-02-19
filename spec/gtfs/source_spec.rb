require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GTFS::Source do
  before(:each) do
    VCR.insert_cassette 'valid_gtfs_uri'
  end
  after(:each) do
    VCR.eject_cassette
  end

  let(:valid_local_source) do
    File.expand_path(File.dirname(__FILE__) + '/../fixtures/valid_gtfs.zip')
  end

  let(:source_missing_required_files) do
    File.expand_path(File.dirname(__FILE__) + '/../fixtures/missing_files.zip')
  end

  let (:valid_local_source_missing_optional_files) do
    File.expand_path(File.dirname(__FILE__) + '/../fixtures/valid_gtfs_missing_optional_files.zip')
  end

  describe '#build' do
    let(:opts) {{}}
    let(:data_source) {valid_local_source}
    subject {GTFS::Source.build(data_source, opts)}

    context 'with a url as a data root' do
      let(:data_source) {'https://developers.google.com/transit/gtfs/examples/sample-feed.zip'}

      it {should be_instance_of GTFS::URLSource}
      its(:options) {should == GTFS::Source::DEFAULT_OPTIONS}
    end

    context 'with a file path as a data root' do
      let(:data_source) {valid_local_source}

      it {should be_instance_of GTFS::LocalSource}
      its(:options) {should == GTFS::Source::DEFAULT_OPTIONS}
    end

    context 'with a file object as a data root' do
      let(:data_source) {File.open(valid_local_source)}

      it {should be_instance_of GTFS::LocalSource}
      its(:options) {should == GTFS::Source::DEFAULT_OPTIONS}
    end

    context 'with options to disable strict checks' do
      let(:opts) {{strict: false}}

      its(:options) {should == {strict: false}}
    end
  end

  describe '#new(source)' do
    it 'should not allow a base GTFS::Source to be initialized' do
      lambda {GTFS::Source.new(valid_local_source)}.should raise_exception
    end
  end

  describe '#agencies' do
    subject {source.agencies}

    context 'when the source has agencies' do
      let(:source) {GTFS::Source.build(valid_local_source)}

      it {should_not be_empty}
      its(:first) {should be_an_instance_of(GTFS::Agency)}
    end
  end

  describe '#stops' do
  end

  describe '#routes' do
    context 'when the source is missing routes' do
      let(:source) { GTFS::Source.build source_missing_required_files }

      it do
        expect { source.routes }.to raise_exception GTFS::InvalidSourceException
      end
    end
  end

  describe '#trips' do
  end

  describe '#stop_times' do
  end

  describe '#transfers' do
    subject {source.transfers}

    context 'when the source is missing transfers' do
      let(:source) { GTFS::Source.build valid_local_source_missing_optional_files }

      it {should_not raise_exception GTFS::InvalidSourceException}
      it {should be_empty}
    end
  end
end
