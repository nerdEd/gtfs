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
end
