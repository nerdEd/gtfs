require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GTFS::Translation do
  describe 'Translation.parse_translations' do
    let(:header_line) {"table_name,field_name,language,translation\n"}
    let(:invalid_header_line) {",stop_name,,translation\n"}
    let(:valid_line) {"stops,stop_name,en,Tokyo Station\n"}
    let(:invalid_line) {",,,en\n"}

    subject {GTFS::Translation.parse_translations(source_text, opts)}

    include_examples 'models'
  end
end