require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GTFS::StopTime do
  describe 'StopTime.parse_stop_times' do
    let(:header_line) {"trip_id,arrival_time,departure_time,stop_id,stop_sequence,stop_headsign,pickup_type,drop_off_type,shape_dist_traveled\n"}
    let(:invalid_header_line) {",arrival_time,,stop_id,,stop_headsign,,drop_off_type,\n"}
    let(:valid_line) {"982385,4:34:00,4:34:00,277,1,,0,0,\n"}
    let(:invalid_line) {",,4:34:00,,1,,,0,\n"}

    subject {GTFS::StopTime.parse_stop_times(source_text, opts)}

    include_examples 'models'
  end
end

