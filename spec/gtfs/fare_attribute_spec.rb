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
  describe 'FareAttribute.write_fare_attributes' do
    it "should produce the correct csv output" do
      csv = GTFS::FareAttribute.generate_csv do |fare_attributes|
        fare_attributes << {
          fare_id: 1,
          price: '0.00',
          currency_type: 'USD',
          payment_method: 0,
          transfers: 0,
          agency_id: 4,
          transfer_duration: 0
        }
        fare_attributes << {
          fare_id: 2,
          price: '0.50',
          currency_type: 'USD',
          payment_method: 0,
          transfers: 0,
          agency_id: 5,
          transfer_duration: 0
        }
      end
      csv.should eq("fare_id,price,currency_type,payment_method,transfers,agency_id,transfer_duration\n"+
      "1,0.00,USD,0,0,4,0\n"+
      "2,0.50,USD,0,0,5,0\n")
    end

    it "should filter dynamically unused csv columns" do
      csv = GTFS::FareAttribute.generate_csv do |fare_attributes|
        fare_attributes << {
          fare_id: 1,
          price: '0.00',
          currency_type: 'USD',
          payment_method: 0,
          transfers: 0,
        }
        fare_attributes << {
          fare_id: 2,
          price: '0.50',
          currency_type: 'USD',
          payment_method: 0,
          transfers: 0,
          agency_id: 7
        }
      end
      csv.should eq("fare_id,price,currency_type,payment_method,transfers,agency_id\n"+
      "1,0.00,USD,0,0,\n"+
      "2,0.50,USD,0,0,7\n")
    end

  end
end
