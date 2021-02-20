require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GTFS::Level do
  describe 'Level.parse_levels' do
    let(:header_line) {"level_id,level_index\n"}
    let(:invalid_header_line) {",level_index\n"}
    let(:valid_line) {"L0,0\n"}
    let(:invalid_line) {",1\n"}

    subject {GTFS::Level.parse_levels(source_text, opts)}

    include_examples 'models'
  end
end