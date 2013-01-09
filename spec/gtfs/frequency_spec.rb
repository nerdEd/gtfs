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
end
