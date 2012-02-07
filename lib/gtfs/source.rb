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

      raise InvalidSourceException.new('Missing required source files') if missing_sources?
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

    def missing_sources?
      return true if @source.nil?

      REQUIRED_SOURCE_FILES.each do |rf|
        return true if !entries.include?(rf)
      end
      false
    end

    def agencies
      open(File.join(@tmp_dir, '/', 'agency.txt')) do |f|
        @agencies ||= Agency.parse_agencies(f.read)
      end
      @agencies
    end
  end
end
