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

  describe 'Shape.generate_shapes' do
    it "should produce the correct csv output" do
      csv = GTFS::Shape.generate_csv do |shapes|
        shapes << {
          id: 'A_shp',
          pt_lat: 37.61956,
          pt_lon: -122.48161,
          pt_sequence: 1,
          dist_traveled: 0,
        }
      end
      csv.should eq("shape_id,shape_pt_lat,shape_pt_lon,shape_pt_sequence,shape_dist_traveled\n"+
      "A_shp,37.61956,-122.48161,1,0\n")
    end

    it "should filter dynamically unused csv columns" do
      csv = GTFS::Shape.generate_csv do |shapes|
        shapes << {
          id: 'A_shp',
          pt_lat: 37.61956,
          pt_lon: -122.48161,
          pt_sequence: 1,
          dist_traveled: 0,
        }
        shapes << {
          id: 'A_shp',
          pt_lat: 37.61956,
          pt_lon: -122.48161,
          pt_sequence: 1,
        }
      end
      csv.should eq("shape_id,shape_pt_lat,shape_pt_lon,shape_pt_sequence,shape_dist_traveled\n"+
      "A_shp,37.61956,-122.48161,1,0\n"+
      "A_shp,37.61956,-122.48161,1,\n"
      )
    end
  end
end
