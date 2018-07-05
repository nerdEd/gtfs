require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GTFS::Transfer do
  describe '#parse_transfers' do
    let(:header_line) {"from_stop_id,to_stop_id,transfer_type,min_transfer_time\n"}
    let(:invalid_header_line) {",toxxtop_id,transfer_type,min_transfer_time\n"}
    let(:valid_line) {"S6,S7,2,300\n"}
    let(:invalid_line) {",S7,2,300\n"}

    subject {GTFS::Transfer.parse_transfers(source_text, opts)}

    include_examples 'models'
  end

  describe 'Transfer.generate_transfers' do
    it "should produce the correct csv output" do
      csv = GTFS::Transfer.generate_csv do |transfers|
        transfers << {
          from_stop_id: 'S6',
          to_stop_id: 'S7',
          type: '2',
          min_transfer_time: '300'
        }
      end
      csv.should eq("from_stop_id,to_stop_id,transfer_type,min_transfer_time\n"+
      "S6,S7,2,300\n")
    end

    it "should filter dynamically unused csv columns" do
      csv = GTFS::Transfer.generate_csv do |transfers|
        transfers << {
          from_stop_id: 'S6',
          to_stop_id: 'S7',
          type: '2',
          min_transfer_time: '300'
        }
        transfers << {
          from_stop_id: 'S7',
          to_stop_id: 'S6',
          type: '3',
        }
      end
      csv.should eq("from_stop_id,to_stop_id,transfer_type,min_transfer_time\n"+
      "S6,S7,2,300\n"+
      "S7,S6,3,\n"
      )
    end
  end
end
