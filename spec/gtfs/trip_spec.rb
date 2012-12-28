require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GTFS::Trip do
  describe 'Trip.parse_trips' do
    let(:header_line) {"route_id,service_id,trip_id,trip_headsign,direction_id,block_id,shape_id\n"}
    let(:invalid_header_line) {",,,,direction_id,block_id,shape_id\n"}
    let(:valid_line) {"4679,1,982394,1 FT McHENRY,0,189021,59135\n"}
    let(:invalid_line) {",1,,1 FT McHENRY,,189021,\n"}

    subject {GTFS::Trip.parse_trips(source_text, opts)}

    include_examples 'models'
  end
end


