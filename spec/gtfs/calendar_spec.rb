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
  #    has_attributes :service_id, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday, :start_date, :end_date
  describe 'Calendar.write_calendars' do
    it "should produce the correct csv output" do
      csv = GTFS::Calendar.generate_csv do |calendars|
        calendars << {
          service_id: 'WE',
          monday: 0,
          tuesday: 0,
          wednesday: 0,
          thursday: 0,
          friday: 0,
          saturday: 1,
          sunday: 1,
          start_date: '20060701',
          end_date: '20060731'
        }
        calendars << {
          service_id: 'WD',
          monday: 1,
          tuesday: 1,
          wednesday: 1,
          thursday: 1,
          friday: 1,
          saturday: 0,
          sunday: 0,
          start_date: 20060701,
          end_date: 20060731
        }
      end
      csv.should eq("service_id,monday,tuesday,wednesday,thursday,friday,saturday,sunday,start_date,end_date\n"+
      "WE,0,0,0,0,0,1,1,20060701,20060731\n"+
      "WD,1,1,1,1,1,0,0,20060701,20060731\n")
    end

  end
end
