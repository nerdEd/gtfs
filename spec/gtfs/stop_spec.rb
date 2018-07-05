require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GTFS::Stop do
  describe 'Trip.parse_stops' do
    let(:header_line) {"stop_id,stop_code,stop_name,stop_lat,stop_lon,zone_id,stop_url,location_type,parent_station\n"}
    let(:invalid_header_line) {"stop_lon, zone_id, stop_url, location_type\n"}
    let(:valid_line) {"3,C093,LANIER & SINAI HOSPITAL,39.351145,-76.663113,,,,\n"}
    let(:invalid_line) {"3,,,,-76.663113,,,,\n"}

    subject {GTFS::Stop.parse_stops(source_text, opts)}

    include_examples 'models'
  end

  describe 'Stop.generate_stops' do
    it "should produce the correct csv output" do
      csv = GTFS::Stop.generate_stops do |stops|
        stops << {
          id: 'S1',
          name: 'Mission St. & Silver Ave.',
          desc: 'The stop is located at the southwest corner of the intersection.',
          lat: '37.728631',
          lon: '-122.431282',
          url: 'http://test.test/test',
          location_type: 1,
          parent_station: 'S8'
        }
      end
      csv.should eq("stop_id,stop_name,stop_desc,stop_lat,stop_lon,stop_url,location_type,parent_station\n"+
      "S1,Mission St. & Silver Ave.,The stop is located at the southwest corner of the intersection.,37.728631,-122.431282,http://test.test/test,1,S8\n")
    end

    it "should filter dynamically unused csv columns" do
      csv = GTFS::Stop.generate_stops do |stops|
        stops << {
          id: 'S1',
          name: 'Mission St. & Silver Ave.',
          lat: '37.728631',
          lon: '-122.431282',
          url: 'http://test.test/test',
          location_type: 1,
          parent_station: 'S8'
        }
        stops << {
          id: 'S1',
          name: 'Mission St. & Silver Ave.',
          lat: '37.728631',
          lon: '-122.431282',
          location_type: 1,
          parent_station: 'S8'
        }
        stops << {
          id: 'S1',
          name: 'Mission St. & Silver Ave.',
          lat: '37.728631',
          lon: '-122.431282',
          url: 'http://test.test/test',
          location_type: 1,
          parent_station: 'S8'
        }
      end
      csv.should eq("stop_id,stop_name,stop_lat,stop_lon,stop_url,location_type,parent_station\n"+
      "S1,Mission St. & Silver Ave.,37.728631,-122.431282,http://test.test/test,1,S8\n"+
      "S1,Mission St. & Silver Ave.,37.728631,-122.431282,,1,S8\n"+
      "S1,Mission St. & Silver Ave.,37.728631,-122.431282,http://test.test/test,1,S8\n"
      )
    end
  end
end

