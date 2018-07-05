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
  describe 'Agency.write_agencies' do


    it "should produce the correct csv output" do
      csv = GTFS::CalendarDate.generate_date_calendar do |date_calendars|
        date_calendars << {
          service_id: 1,
          date: '19900521',
          exception_type: '1'
        }
        date_calendars << {
          service_id: 2,
          date: '20170521',
          exception_type: '2'
        }
      end
      csv.should eq("service_id,date,exception_type\n1,19900521,1\n2,20170521,2")
    end

  end
end
