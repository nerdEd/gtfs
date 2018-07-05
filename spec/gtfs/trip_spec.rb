require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GTFS::Trip do
  describe 'Trip.parse_trips' do
    let(:header_line) {"route_id,service_id,trip_id,trip_headsign,direction_id,block_id,shape_id,bikes_allowed\n"}
    let(:invalid_header_line) {",,,,direction_id,block_id,shape_id\n"}
    let(:valid_line) {"4679,1,982394,1 FT McHENRY,0,189021,59135\n"}
    let(:invalid_line) {",1,,1 FT McHENRY,,189021,\n"}

    subject {GTFS::Trip.parse_trips(source_text, opts)}

    include_examples 'models'
  end

  describe 'Trip.generate_trips' do
    it "should produce the correct csv output" do
      csv = GTFS::Trip.generate_csv do |trips|
        trips << {
          route_id: 'A',
          service_id: 'WE',
          id: 'AWE1',
          headsign: 'Downtown',
          block_id: '1'
        }
      end
      csv.should eq("route_id,service_id,trip_id,trip_headsign,block_id\n"+
      "A,WE,AWE1,Downtown,1\n")
    end

    it "should filter dynamically unused csv columns" do
      csv = GTFS::Trip.generate_csv do |trips|
        trips << {
          route_id: 'A',
          service_id: 'WE',
          id: 'AWE1',
          headsign: 'Downtown',
        }
        trips << {
          route_id: 'A',
          service_id: 'WE',
          id: 'AWE1',
        }
        trips << {
          route_id: 'A',
          service_id: 'WE',
          id: 'AWE1',
          headsign: 'Downtown',
        }
      end
      csv.should eq("route_id,service_id,trip_id,trip_headsign\n"+
      "A,WE,AWE1,Downtown\n"+
      "A,WE,AWE1,\n"+
      "A,WE,AWE1,Downtown\n"
      )
    end
  end
end