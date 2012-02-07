require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GTFS::Source do
  let(:valid_local_source) {File.expand_path(File.dirname(__FILE__) + '/../fixtures/valid_gtfs.zip')}

  describe '#build' do
    subject {GTFS::Source.build(data_source)}
    before do
      GTFS::URLSource.stub(:new).and_return('URLSource')
      GTFS::LocalSource.stub(:new).and_return('LocalSource')
    end

    context 'with a url as a data root' do
      let(:data_source) {'http://www.edschmalzle.com/gtfs.zip'}

      it {should == 'URLSource'}
    end

    context 'with a file path as a data root' do
      let(:data_source) {valid_local_source}

      it {should == 'LocalSource'}
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
  end

  describe '#trips' do
  end

  describe '#stop_times' do
  end
end
