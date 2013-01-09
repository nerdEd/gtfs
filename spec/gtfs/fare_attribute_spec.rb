require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GTFS::FareAttribute do
  describe '.parse_fare_attributes' do
    let(:header_line) {"fare_id,price,currency_type,payment_method,transfers,transfer_duration\n"}
    let(:invalid_header_line) {",,currency_type,,,transfer_duration\n"}
    let(:valid_line) {"1,1.23,USD,0, ,5000\n"}
    let(:invalid_line) {"1,,,0, ,5000\n"}

    subject {GTFS::FareAttribute.parse_fare_attributes(source_text, opts)}

    include_examples 'models'
  end
end
