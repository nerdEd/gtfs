require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GTFS::Attribution do
  describe 'Attribution.parse_attributions' do
    let(:header_line) {"organization_name\n"}
    let(:invalid_header_line) {"\n"}
    let(:valid_line) {"Transit Feed Solutions Tokyo\n"}
    let(:invalid_line) {"\n"}

    subject {GTFS::Attribution.parse_attributions(source_text, opts)}

    include_examples 'models'
  end
end