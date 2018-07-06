require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GTFS::Frequency do
  describe '#parse_frequncies' do
    let(:header_line) {"trip_id,start_time,end_time,headway_secs\n"}
    let(:invalid_header_line) {",,end_time,headway_secs\n"}
    let(:valid_line) {"AWE1,05:30:00,06:30:00,300\n"}
    let(:invalid_line) {",,06:30:00,300\n"}

    subject {GTFS::Frequency.parse_frequencies(source_text, opts)}

    include_examples 'models'
  end

  describe 'Frequency.generate_frequencies' do
    it "should produce the correct csv output" do
      csv = GTFS::Frequency.generate_csv do |frequencies|
        frequencies << {
          trip_id: 'AWE1',
          start_time: '05:30:00',
          end_time: '06:30:00',
          headway_secs: 300,
          exact_times: 0
        }
      end
      csv.should eq("trip_id,start_time,end_time,headway_secs,exact_times\n"+
      "AWE1,05:30:00,06:30:00,300,0\n")
    end

    it "should filter dynamically unused csv columns" do
      csv = GTFS::Frequency.generate_csv do |frequencies|
        frequencies << {
          trip_id: 'AWE1',
          start_time: '05:30:00',
          end_time: '06:30:00',
          headway_secs: 300,
          exact_times: 0
        }
        frequencies << {
          trip_id: 'AWE1',
          start_time: '05:30:00',
          end_time: '06:30:00',
          headway_secs: 300
        }
      end
      csv.should eq("trip_id,start_time,end_time,headway_secs,exact_times\n"+
      "AWE1,05:30:00,06:30:00,300,0\n"+
      "AWE1,05:30:00,06:30:00,300,\n"
      )
    end
  end
end
