require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GTFS::FareRule do
  describe '.parse_fare_rules' do
    let(:header_line) {"fare_id,route_id,origin_id,destination_id,contains_id\n"}
    let(:invalid_header_line) {",route_id,origin_id,destination_id,contains_id\n"}
    let(:valid_line) {"1,2,TWS,,\n"}
    let(:invalid_line) {",2,TWS,,\n"}
    subject {GTFS::FareRule.parse_fare_rules(source_text, opts)}

    include_examples 'models'
  end

  describe 'FareRules.write_fare_rules' do
    it "should produce the correct csv output" do
      csv = GTFS::FareRule.generate_csv do |fare_rules|
        fare_rules << {
          fare_id: 'a',
          route_id: 'TSW',
          origin_id: 1,
          destination_id: 1,
          contains_id: 7
        }
        fare_rules << {
          fare_id: 'a',
          route_id: 'TSE',
          origin_id: 1,
          destination_id: 1,
          contains_id: 9
        }
      end
      csv.should eq("fare_id,route_id,origin_id,destination_id,contains_id\n"+
      "a,TSW,1,1,7\n"+
      "a,TSE,1,1,9\n")
    end

    it "should filter dynamically unused csv columns" do
      csv = GTFS::FareRule.generate_csv do |fare_rules|
        fare_rules << {
          fare_id: 'a',
          destination_id: 1,
        }
        fare_rules << {
          fare_id: 'a',
          route_id: 'TSE',
        }
      end
      csv.should eq("fare_id,route_id,destination_id\n"+
      "a,,1\n"+
      "a,TSE,\n")
    end

  end
end
