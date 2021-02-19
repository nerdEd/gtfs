require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GTFS::Route do
  describe 'Route.parse_routes' do
    let(:header_line) {"route_id,agency_id,route_short_name,route_long_name,route_desc,route_type,route_url,route_color,route_text_color\n"}
    let(:invalid_header_line) {",agency_id,,route_long_name,,route_type,,route_color,\n"}
    let(:valid_line) {"4679,1,001,SINAI - FORT McHENRY,,3,,0000FF,FFFFFF\n"}
    let(:invalid_line) {",1,,,,3,,,FFFFFF\n"}

    subject {GTFS::Route.parse_routes(source_text, opts)}

    include_examples 'models'

    context '#valid' do
      let(:opts) {{}}
      let(:source_text) {header_line + valid_line}

      context 'routes with only short name' do
        let(:valid_line) {"4679,1,001,,,3,,0000FF,FFFFFF\n"}

        it "are valid" do
          subject.first.valid?.should == true
        end
      end

      context 'routes with only long name' do
        let(:valid_line) {"4679,1,,SINAI - FORT McHENRY,,3,,0000FF,FFFFFF\n"}

        it "are valid" do
          subject.first.valid?.should == true
        end
      end
    end
  end
end
