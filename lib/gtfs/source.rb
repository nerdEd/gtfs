require 'tmpdir'
require 'fileutils'
require 'zip/zip'

module GTFS
  class Source

    REQUIRED_SOURCE_FILES = %w{agency.txt stops.txt routes.txt trips.txt stop_times.txt calendar.txt}
    OPTIONAL_SOURCE_FILES = %w{calendar_dates.txt fare_attributes.txt fare_rules.txt shapes.txt frequencies.txt transfers.txt}
    SOURCE_FILES = REQUIRED_SOURCE_FILES + OPTIONAL_SOURCE_FILES

    attr_accessor :source, :archive

    def initialize(source)
      raise 'Source cannot be nil' if source.nil?

      @tmp_dir = Dir.mktmpdir
      ObjectSpace.define_finalizer(self, self.class.finalize(@tmp_dir))

      @source = source
      load_archive(@source)
    end

    def self.finalize(directory)
      proc {FileUtils.rm_rf(directory)}
    end

    def extract_to_cache(source_path)
      Zip::ZipFile.open(source_path) do |zip|
        zip.entries.each do |entry|
          zip.extract(entry.name, File.join(@tmp_dir, '/', entry.name))
        end
      end
    end

    def load_archive(source)
      raise 'Cannot directly instantiate base GTFS::Source'
    end

    def self.build(data_root)
      if data_root.match(/http|www/) 
        URLSource.new(data_root) 
      else
        LocalSource.new(data_root)
      end
    end

    def entries
      Dir.entries(@tmp_dir)
    end

    def raise_if_missing_source(filename)
      file_missing = !entries.include?(filename)
      raise InvalidSourceException.new("Missing required source file: #{filename}") if file_missing
    end

    def agencies
      parse_file 'agency.txt' do |f|
        Agency.parse_agencies(f.read)
      end
    end

    def stops
      parse_file 'stops.txt' do |f|
        Stop.parse_stops(f.read)
      end
    end

    def calendars
      parse_file 'calendar.txt' do |f|
        Calendar.parse_calendars(f.read)
      end
    end

    def routes
      parse_file 'routes.txt' do |f|
        Route.parse_routes(f.read)
      end
    end

    # TODO: huge, isn't practical to parse all at once
    def shapes
      parse_file 'shapes.txt' do |f|
        Shape.parse_shapes(f.read)
      end
    end

    def trips
      parse_file 'trips.txt' do |f|
        Trip.parse_trips(f.read)
      end
    end

    # TODO: huge, isn't practical to parse all at once
    def stop_times
      parse_file 'stop_times.txt' do |f|
        StopTime.parse_stop_times f.read
      end
    end

    def files
      @files ||= {}
    end

    def parse_file(filename)
      raise_if_missing_source filename
      open File.join(@tmp_dir, '/', filename) do |f|
        files[filename] ||= yield f
      end
    end
  end
end
