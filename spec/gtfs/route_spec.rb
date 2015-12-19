require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GTFS::Route do
  describe 'Route.parse_models' do
    let(:header_line) {"route_id,agency_id,route_short_name,route_long_name,route_desc,route_type,route_url,route_color,route_text_color\n"}
    let(:invalid_header_line) {",agency_id,,route_long_name,,route_type,,route_color,\n"}
    let(:valid_line) {"4679,1,001,SINAI - FORT McHENRY,,3,,0000FF,FFFFFF\n"}
    let(:invalid_line) {",1,,,,3,,,FFFFFF\n"}

    subject {GTFS::Route.parse_models(source_text, opts)}

    include_examples 'models'
  end

  context 'GTFS::Route.gtfs_vehicle_type' do
    it 'returns vehicle_type from string' do
      route = GTFS::Route.new({route_type: '0'})
      route.gtfs_vehicle_type.should eq(:Tram)
    end
    it 'returns vehicle_type from symbol' do
      route = GTFS::Route.new({route_type: :'0'})
      route.gtfs_vehicle_type.should eq(:Tram)
    end
    it 'returns vehicle_type from integer' do
      route = GTFS::Route.new({route_type: 0})
      route.gtfs_vehicle_type.should eq(:Tram)
    end
    it 'supports extended vehicle_types' do
      route = GTFS::Route.new({route_type: 100})
      route.gtfs_vehicle_type.should eq(:'Railway Service')
    end
  end
end
