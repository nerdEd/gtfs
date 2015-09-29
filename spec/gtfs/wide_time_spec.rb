require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GTFS::WideTime do
  describe 'test' do
    it 'supports more than 24 hours'
    it 'adds WideTimes'
    it 'subtracts WideTimes'
    it 'parses from string'
    it 'formats to GTFS stop_times'
  end
end
