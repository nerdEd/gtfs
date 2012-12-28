require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GTFS::Shape do
  describe 'Shape.parse_shapes' do
    let(:header_line) {"shape_id,shape_pt_lat,shape_pt_lon,shape_pt_sequence,shape_dist_traveled\n"}
    let(:invalid_header_line) {",,,shape_pt_sequence,shape_dist_traveled\n"}
    let(:valid_line) {"59135,39.354286,-76.662453,19,0.8136\n"}
    let(:invalid_line) {",39.354286,,,0.8136\n"}

    subject {GTFS::Shape.parse_shapes(source_text, opts)}

    include_examples 'models'
  end
end
