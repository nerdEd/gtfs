require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GTFS::Calendar do
  describe 'Calendar.parse_calendars' do
    let(:header_line) {"service_id,monday,tuesday,wednesday,thursday,friday,saturday,sunday,start_date,end_date\n"}
    let(:invalid_header_line) {"service_id,,tuesday,,thursday,friday,,sunday,start_date,end_date\n"}
    let(:valid_line) {"1,1,1,1,1,1,0,0,20110828,20120204\n"}
    let(:invalid_line) {"1,,1,,1,,0,,,20120204\n"}

    subject {GTFS::Calendar.parse_calendars(source_text, opts)}

    include_examples 'models'
  end
end
