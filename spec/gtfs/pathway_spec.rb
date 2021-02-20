require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GTFS::Pathway do
  describe 'Pathway.parse_pathways' do
    let(:header_line) {"pathway_id,from_stop_id,to_stop_id,pathway_mode,is_bidirectional\n"}
    let(:invalid_header_line) {",rom_stop_id,to_stop_id,pathway_mode,is_bidirectional\n"}
    let(:valid_line) {"E1N1,E1,N1,2,1\n"}
    let(:invalid_line) {"E1N1,E1,,,1\n"}

    subject {GTFS::Pathway.parse_pathways(source_text, opts)}

    include_examples 'models'
  end
end