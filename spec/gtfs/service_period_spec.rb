require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GTFS::ServicePeriod do
  let(:valid_local_source) do
    File.expand_path(File.dirname(__FILE__) + '/../fixtures/valid_gtfs.zip')
  end

  describe 'test' do
    let(:data_source) {valid_local_source}
    let(:opts) {{}}

    it 'has a service_period' do
      source = GTFS::LocalSource.new(data_source, opts)
      source.load_service_periods
      sp = source.service_period('1')
    end

  end
end
