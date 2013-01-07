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
end
