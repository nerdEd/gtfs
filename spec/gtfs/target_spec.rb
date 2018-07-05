require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GTFS::Target do
  describe 'Target.open' do
    it "should produce the correct export zip" do
      GTFS::Target.open("/tmp/GTFSexport/test.zip") do |target|
        target.stop_times do |stop_times|
          stop_times << {
            trip_id: 'AWE1',
            arrival_time: '0:06:10',
            departure_time: '0:06:10',
            stop_id: 'S1',
            stop_sequence: 1,
            pickup_type: 0,
            drop_off_type: 0,
          }
        end
      end
      true.should eq(false)
    end
  end
end
