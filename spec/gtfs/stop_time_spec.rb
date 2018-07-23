require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GTFS::StopTime do
  describe 'StopTime.parse_stop_times' do
    let(:header_line) {"trip_id,arrival_time,departure_time,stop_id,stop_sequence,stop_headsign,pickup_type,drop_off_type,shape_dist_traveled,timepoint\n"}
    let(:invalid_header_line) {",arrival_time,,stop_id,,stop_headsign,,drop_off_type,\n"}
    let(:valid_line) {"982385,4:34:00,4:34:00,277,1,,0,0,\n"}
    let(:invalid_line) {",,4:34:00,,1,,,0,\n"}

    subject {GTFS::StopTime.parse_stop_times(source_text, opts)}

    include_examples 'models'
  end

  describe 'Stop_time.generate_stop_times' do
    it "should produce the correct csv output" do
      csv = GTFS::StopTime.generate_csv do |stop_times|
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
      csv.should eq("trip_id,arrival_time,departure_time,stop_id,stop_sequence,pickup_type,drop_off_type\n"+
      "AWE1,0:06:10,0:06:10,S1,1,0,0\n")
    end

    it "should filter dynamically unused csv columns" do
      csv = GTFS::StopTime.generate_csv do |stop_times|
        stop_times << {
          trip_id: 'AWE1',
          arrival_time: '0:06:10',
          departure_time: '0:06:10',
          stop_id: 'S1',
          stop_sequence: 1,
          pickup_type: 0,
        }
        stop_times << {
          trip_id: 'AWE1',
          arrival_time: '0:06:10',
          departure_time: '0:06:10',
          stop_id: 'S1',
          stop_sequence: 1,
        }
        stop_times << {
          trip_id: 'AWE1',
          arrival_time: '0:06:10',
          departure_time: '0:06:10',
          stop_id: 'S1',
          stop_sequence: 1,
          pickup_type: 0,
        }
      end
      csv.should eq("trip_id,arrival_time,departure_time,stop_id,stop_sequence,pickup_type\n"+
      "AWE1,0:06:10,0:06:10,S1,1,0\n"+
      "AWE1,0:06:10,0:06:10,S1,1,\n"+
      "AWE1,0:06:10,0:06:10,S1,1,0\n"
      )
    end
  end
end

