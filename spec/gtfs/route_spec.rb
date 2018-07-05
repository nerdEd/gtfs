require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GTFS::Route do
  describe 'Route.parse_routes' do
    let(:header_line) {"route_id,agency_id,route_short_name,route_long_name,route_desc,route_type,route_url,route_color,route_text_color\n"}
    let(:invalid_header_line) {",agency_id,,route_long_name,,route_type,,route_color,\n"}
    let(:valid_line) {"4679,1,001,SINAI - FORT McHENRY,,3,,0000FF,FFFFFF\n"}
    let(:invalid_line) {",1,,,,3,,,FFFFFF\n"}

    subject {GTFS::Route.parse_routes(source_text, opts)}

    include_examples 'models'
  end

  describe 'Route.generate_routes' do
    it "should produce the correct csv output" do
      csv = GTFS::Route.generate_csv do |routes|
        routes << {
          id: 'A',
          short_name: '17',
          long_name: 'Mission',
          desc: 'The "A" route travels from lower Mission to Downtown.',
          type: 3,
          url: 'http://test.test/test'
        }
      end
      csv.should eq("route_id,route_short_name,route_long_name,route_desc,route_type,route_url\n"+
      "A,17,Mission,\"The \"\"A\"\" route travels from lower Mission to Downtown.\",3,http://test.test/test\n")
    end

    it "should filter dynamically unused csv columns" do
      csv = GTFS::Route.generate_csv do |routes|
        routes << {
          id: 'A',
          short_name: '17',
          long_name: 'Mission',
          type: 3,
          url: 'http://test.test/test'
        }
        routes << {
          id: 'A',
          short_name: '17',
          long_name: 'Mission',
          type: 3
        }
        routes << {
          id: 'A',
          short_name: '17',
          long_name: 'Mission',
          type: 3,
          url: 'http://test.test/test'
        }
      end
      csv.should eq("route_id,route_short_name,route_long_name,route_type,route_url\n"+
      "A,17,Mission,3,http://test.test/test\n"+
      "A,17,Mission,3,\n"+
      "A,17,Mission,3,http://test.test/test\n"
      )
    end
  end
end