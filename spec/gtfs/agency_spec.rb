require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GTFS::Agency do
  describe 'Agency.parse_agencies' do
    let(:header_line) {"agency_id,agency_name,agency_url,agency_timezone,agency_lang,agency_phone\n"}
    let(:invalid_header_line) {"agency_id,agency_url,agency_timezone,agency_lang,agency_phone\n"}
    let(:valid_line) {"1,Maryland Transit Administration,http://www.mta.maryland.gov,America/New_York,en,410-539-5000\n"}
    let(:invalid_line) {"1,,http://www.mta.maryland.gov,America/New_York,en,410-539-5000\n"}

    subject {GTFS::Agency.parse_agencies(source_text)}

    context 'with a nil source' do
      let(:source_text) {nil}
      it {should == []}
    end

    context 'with an empty source' do
      let(:source_text) {''}
      it {should == []}
    end

    context 'with a source w/ only headers' do
      let(:source_text) {"agency_id,agency_name,agency_url,agency_timezone,agency_lang,agency_phone\n"}
      it {should == []}
    end

    context 'with a valid row of data' do
      let(:source_text) {header_line + valid_line}
      its(:size) {should == 1}
    end

    context 'with multiple valid rows of data' do
      let(:source_text) {header_line + valid_line + valid_line}
      its(:size) {should == 2}
    end

    context 'with 1 invalid and 1 valid row of data' do
      let(:source_text) {header_line + valid_line + invalid_line}
      its(:size) {should == 1}
    end
  end
end
