require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GTFS::Source do
  describe '#build' do
    context 'with a url as a data root' do
      it 'should return an instance of url source' do
      end
    end

    context 'with a file path as a data root' do
      it 'should return an instance of local source' do
      end
    end

    context 'with no data root' do
      it 'should throw an invalid source exception' do
      end
    end
  end

  describe '#local_source?' do
  end

  describe '#agencies' do
  end

  describe '#stops' do
  end

  describe '#routes' do
  end

  describe '#trips' do
  end

  describe '#stop_times' do
  end
end
