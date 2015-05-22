require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GTFS::Trip do
  describe 'Trip.parse_trips' do
    let(:header_line) {"route_id,service_id,trip_id,trip_headsign,direction_id,block_id,shape_id,wheelchair_accessible,bikes_allowed\n"}
    let(:invalid_header_line) {",,,,direction_id,block_id,shape_id\n"}
    let(:valid_line) {"4679,1,982394,1 FT McHENRY,0,189021,59135,1,1\n"}
    let(:invalid_line) {",1,,1 FT McHENRY,,189021,\n"}

    subject {GTFS::Trip.parse_trips(source_text, opts)}

    include_examples 'models'

    context "with a valid file" do
      let(:opts) {{}}
      let(:source_text) {header_line + valid_line}

      it "makes wheelchair_accessible attribute available" do
        subject.first.wheelchair_accessible.should == "1"
      end

      it "makes bikes_allowed attribute available" do
        subject.first.bikes_allowed.should == "1"
      end
    end
  end
end


