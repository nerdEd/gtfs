shared_examples 'models' do |collection_class|
  context 'with a nil source' do
    let(:source_text) {nil}
    it {should == []}
  end

  context 'with an empty source' do
    let(:source_text) {''}
    it {should == []}
  end

  context 'with a source w/ only headers' do
    let(:source_text) {header_line}
    it {should == []}
  end

  context 'with a valid row of data' do
    let(:source_text) {header_line + valid_line}
    its(:size) {should == 1}
  end

  context 'with multiple valid rows of data' do
    let(:source_text) {header_line + valid_line + valid_line}
    its(:size) {should == 2}
  end

  context 'with 1 invalid and 1 valid row of data' do
    let(:source_text) {header_line + valid_line + invalid_line}
    its(:size) {should == 1}
  end
end
