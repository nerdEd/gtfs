require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GTFS::CalendarDate do
  describe 'CalendarDate.parse_calendar_dates' do
    let(:header_line) {"service_id,date,exception_type\n"}
    let(:invalid_header_line) {",date,\n"}
    let(:valid_line) {"3,20110905,1\n"}
    let(:invalid_line) {"3,,1\n"}

    subject {GTFS::CalendarDate.parse_calendar_dates(source_text, opts)}

    include_examples 'models'
  end
end
