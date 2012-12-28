require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GTFS::Agency do
  describe 'Agency.parse_agencies' do
    let(:header_line) {"agency_id,agency_name,agency_url,agency_timezone,agency_lang,agency_phone\n"}
    let(:invalid_header_line) {"agency_id,agency_url,agency_timezone,agency_lang,agency_phone\n"}
    let(:valid_line) {"1,Maryland Transit Administration,http://www.mta.maryland.gov,America/New_York,en,410-539-5000\n"}
    let(:invalid_line) {"1,,http://www.mta.maryland.gov,America/New_York,en,410-539-5000\n"}

    subject {GTFS::Agency.parse_agencies(source_text, opts)}

    include_examples 'models'
  end
end
