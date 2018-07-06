require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GTFS::Target do
  describe 'Target.open' do
    def test_entity(entity, map)
      map.each do |k,v|
        entity.send(k).should eq(v)
      end
    end

    it "should produce the correct export zip" do
      tmp_dir = Dir.mktmpdir
      zip_path = File.join(tmp_dir, '/test.zip')

      first_agency = {
        id: '1',
        name: 'MTA',
        url: 'http://www.mta.maryland.gov',
        timezone: 'America/New_York',
        lang: 'en',
        phone: '410-539-5000'
      }
      second_agency = {
        id: '2',
        name: 'MTA2',
        url: 'http://www.mta.maryland.gov/2',
        timezone: 'America/New_York',
        lang: 'en',
        phone: '410-539-5001'
      }
      stop_time = {
          trip_id: 'AWE1',
          arrival_time: '0:06:10',
          departure_time: '0:06:10',
          stop_id: 'S1',
          stop_sequence: '1',
          pickup_type: '0',
          drop_off_type: '0',
        }

      GTFS::Target.open(zip_path) do |target|
        target.agencies << first_agency
        target.agencies << second_agency
        target.stop_times << stop_time
      end

      Zip::File.open(zip_path) do |zip|
        zip.entries.length.should eq(7)
      end

      source = GTFS::Source.build(zip_path)
      source.agencies.length.should eq(2)

      test_entity source.agencies.first, first_agency
      test_entity source.agencies[1], second_agency

      source.stop_times.length.should eq(1)
      test_entity source.stop_times.first, stop_time
    end
  end
end
